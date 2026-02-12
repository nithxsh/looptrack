class PersistentNote {
  final int? id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int orderIndex;

  PersistentNote({
    this.id,
    required this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'orderIndex': orderIndex,
    };
  }

  factory PersistentNote.fromMap(Map<String, dynamic> map) {
    return PersistentNote(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      orderIndex: map['orderIndex'] as int,
    );
  }

  PersistentNote copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? orderIndex,
  }) {
    return PersistentNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}