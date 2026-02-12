import 'database_helper.dart';
import '../models/models.dart';

class HistoryService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<HistoryEntry>> getHistory({int days = 30}) async {
    return await _db.getHistoryEntries(limit: days);
  }

  Future<HistoryEntry?> getTodayEntry() async {
    final now = DateTime.now();
    final dateString =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return await _db.getHistoryEntry(dateString);
  }

  Future<Map<String, dynamic>> getStats() async {
    final entries = await getHistory(days: 30);

    int totalDays = entries.length;
    int totalTasks = 0;
    int completedTasks = 0;
    int perfectDays = 0;
    int bestStreak = 0;
    int currentStreak = 0;

    for (var entry in entries) {
      totalTasks += entry.totalTasks;
      completedTasks += entry.completedTasks;

      if (entry.totalTasks > 0 && entry.completedTasks == entry.totalTasks) {
        perfectDays++;

        currentStreak++;
        if (currentStreak > bestStreak) {
          bestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    return {
      'totalDays': totalDays,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'completionRate': totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0,
      'perfectDays': perfectDays,
      'bestStreak': bestStreak,
      'averageCompletion': totalDays > 0 ? completedTasks / totalDays : 0.0,
    };
  }
}