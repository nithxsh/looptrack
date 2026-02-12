class DailyTask {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? lastCompletedAt;
  final DateTime createdAt;
  final int orderIndex;

  DailyTask({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.lastCompletedAt,
    required this.createdAt,
    required this.orderIndex,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'orderIndex': orderIndex,
    };
  }

  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['isCompleted'] as int?) == 1,
      lastCompletedAt: map['lastCompletedAt'] != null
          ? DateTime.parse(map['lastCompletedAt'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      orderIndex: map['orderIndex'] as int,
    );
  }

  DailyTask copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? lastCompletedAt,
    DateTime? createdAt,
    int? orderIndex,
  }) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      createdAt: createdAt ?? this.createdAt,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}