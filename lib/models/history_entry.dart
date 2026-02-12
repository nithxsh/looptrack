class HistoryEntry {
  final int? id;
  final String date;
  final int completedTasks;
  final int totalTasks;
  final int consistencyScore;

  HistoryEntry({
    this.id,
    required this.date,
    required this.completedTasks,
    required this.totalTasks,
    required this.consistencyScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'consistencyScore': consistencyScore,
    };
  }

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      id: map['id'] as int?,
      date: map['date'] as String,
      completedTasks: map['completedTasks'] as int,
      totalTasks: map['totalTasks'] as int,
      consistencyScore: map['consistencyScore'] as int,
    );
  }

  double get completionRate =>
      totalTasks > 0 ? completedTasks / totalTasks : 0.0;
}