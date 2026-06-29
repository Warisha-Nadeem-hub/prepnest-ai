class LearningCard {
  final String id;
  final String title;
  final String topic;
  final String explanation;
  final List<String> bulletPoints;
  final String interviewQuestion;
  final String sampleAnswer;
  final String quickTip;
  final String readingTime;
  final DateTime generatedAt;

  LearningCard({
    required this.id,
    required this.title,
    required this.topic,
    required this.explanation,
    required this.bulletPoints,
    required this.interviewQuestion,
    required this.sampleAnswer,
    required this.quickTip,
    required this.readingTime,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'topic': topic,
      'explanation': explanation,
      'bulletPoints': bulletPoints,
      'interviewQuestion': interviewQuestion,
      'sampleAnswer': sampleAnswer,
      'quickTip': quickTip,
      'readingTime': readingTime,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  factory LearningCard.fromJson(Map<String, dynamic> json) {
    return LearningCard(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      bulletPoints:
          (json['bulletPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      interviewQuestion: json['interviewQuestion'] as String? ?? '',
      sampleAnswer: json['sampleAnswer'] as String? ?? '',
      quickTip: json['quickTip'] as String? ?? '',
      readingTime: json['readingTime'] as String? ?? '2 min',
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : DateTime.now(),
    );
  }

  LearningCard copyWith({
    String? id,
    String? title,
    String? topic,
    String? explanation,
    List<String>? bulletPoints,
    String? interviewQuestion,
    String? sampleAnswer,
    String? quickTip,
    String? readingTime,
    DateTime? generatedAt,
  }) {
    return LearningCard(
      id: id ?? this.id,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      explanation: explanation ?? this.explanation,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      interviewQuestion: interviewQuestion ?? this.interviewQuestion,
      sampleAnswer: sampleAnswer ?? this.sampleAnswer,
      quickTip: quickTip ?? this.quickTip,
      readingTime: readingTime ?? this.readingTime,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }
}
