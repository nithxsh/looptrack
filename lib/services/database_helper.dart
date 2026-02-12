import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'looptrack.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE daily_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER DEFAULT 0,
        lastCompletedAt TEXT,
        createdAt TEXT NOT NULL,
        orderIndex INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE persistent_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        orderIndex INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE history_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT UNIQUE NOT NULL,
        completedTasks INTEGER NOT NULL,
        totalTasks INTEGER NOT NULL,
        consistencyScore INTEGER NOT NULL
      )
    ''');
  }

  // Daily Tasks CRUD
  Future<int> insertDailyTask(DailyTask task) async {
    final db = await database;
    return await db.insert('daily_tasks', task.toMap());
  }

  Future<List<DailyTask>> getDailyTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('daily_tasks', orderBy: 'orderIndex ASC');
    return List.generate(maps.length, (i) => DailyTask.fromMap(maps[i]));
  }

  Future<int> updateDailyTask(DailyTask task) async {
    final db = await database;
    return await db.update(
      'daily_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteDailyTask(int id) async {
    final db = await database;
    return await db.delete(
      'daily_tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleDailyTask(DailyTask task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      lastCompletedAt: !task.isCompleted ? DateTime.now() : task.lastCompletedAt,
    );
    return await updateDailyTask(updatedTask);
  }

  // Persistent Notes CRUD
  Future<int> insertPersistentNote(PersistentNote note) async {
    final db = await database;
    return await db.insert('persistent_notes', note.toMap());
  }

  Future<List<PersistentNote>> getPersistentNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('persistent_notes', orderBy: 'orderIndex ASC');
    return List.generate(maps.length, (i) => PersistentNote.fromMap(maps[i]));
  }

  Future<int> updatePersistentNote(PersistentNote note) async {
    final db = await database;
    return await db.update(
      'persistent_notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deletePersistentNote(int id) async {
    final db = await database;
    return await db.delete(
      'persistent_notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // History CRUD
  Future<int> insertOrUpdateHistoryEntry(HistoryEntry entry) async {
    final db = await database;
    return await db.insert(
      'history_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<HistoryEntry?> getHistoryEntry(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history_entries',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return HistoryEntry.fromMap(maps.first);
  }

  Future<List<HistoryEntry>> getHistoryEntries({int limit = 30}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history_entries',
      orderBy: 'date DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => HistoryEntry.fromMap(maps[i]));
  }

  // Reset all daily tasks
  Future<int> resetAllDailyTasks() async {
    final db = await database;
    return await db.update(
      'daily_tasks',
      {'isCompleted': 0},
      where: 'isCompleted = ?',
      whereArgs: [1],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}