import 'database_helper.dart';
import '../models/models.dart';

class DailyTasksService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<DailyTask>> getAllTasks() async {
    return await _db.getDailyTasks();
  }

  Future<DailyTask> addTask(String title, {String? description}) async {
    final tasks = await getAllTasks();
    final task = DailyTask(
      title: title,
      description: description,
      createdAt: DateTime.now(),
      orderIndex: tasks.length,
    );
    task.id = await _db.insertDailyTask(task);
    return task;
  }

  Future<void> updateTask(DailyTask task) async {
    await _db.updateDailyTask(task);
  }

  Future<void> toggleTask(DailyTask task) async {
    await _db.toggleDailyTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteDailyTask(id);
    await _reorderTasks();
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    final tasks = await getAllTasks();
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final task = tasks.removeAt(oldIndex);

    tasks.insert(newIndex, task);

    for (int i = 0; i < tasks.length; i++) {
      await _db.updateDailyTask(tasks[i].copyWith(orderIndex: i));
    }
  }

  Future<void> _reorderTasks() async {
    final tasks = await getAllTasks();
    for (int i = 0; i < tasks.length; i++) {
      await _db.updateDailyTask(tasks[i].copyWith(orderIndex: i));
    }
  }

  Future<int> getCompletionCount() async {
    final tasks = await getAllTasks();
    return tasks.where((t) => t.isCompleted).length;
  }

  Future<double> getCompletionRate() async {
    final tasks = await getAllTasks();
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isCompleted).length;
    return completed / tasks.length;
  }
}