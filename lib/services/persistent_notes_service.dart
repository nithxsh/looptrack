import 'database_helper.dart';
import '../models/models.dart';

class PersistentNotesService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<PersistentNote>> getAllNotes() async {
    return await _db.getPersistentNotes();
  }

  Future<PersistentNote> addNote(String title, {String? content}) async {
    final notes = await getAllNotes();
    final now = DateTime.now();
    final note = PersistentNote(
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      orderIndex: notes.length,
    );
    note.id = await _db.insertPersistentNote(note);
    return note;
  }

  Future<void> updateNote(PersistentNote note) async {
    await _db.updatePersistentNote(
      note.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<void> deleteNote(int id) async {
    await _db.deletePersistentNote(id);
    await _reorderNotes();
  }

  Future<void> reorderNotes(int oldIndex, int newIndex) async {
    final notes = await getAllNotes();
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final note = notes.removeAt(oldIndex);
    notes.insert(newIndex, note);

    for (int i = 0; i < notes.length; i++) {
      await _db.updatePersistentNote(notes[i].copyWith(orderIndex: i));
    }
  }

  Future<void> _reorderNotes() async {
    final notes = await getAllNotes();
    for (int i = 0; i < notes.length; i++) {
      await _db.updatePersistentNote(notes[i].copyWith(orderIndex: i));
    }
  }
}