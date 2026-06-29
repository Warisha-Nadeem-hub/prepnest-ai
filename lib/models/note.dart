class Note {
  final String id;
  final String title;
  final String content;
  final String topic;
  final DateTime createdAt;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.topic,
    required this.createdAt,
    this.isPinned = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'topic': topic,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? topic,
    DateTime? createdAt,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      topic: topic ?? this.topic,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
