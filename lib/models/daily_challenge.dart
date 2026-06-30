class InterviewChallenge {
  final String id;
  final String topic;
  final String difficulty;
  final String question;
  final String answer;

  InterviewChallenge({
    required this.id,
    required this.topic,
    required this.difficulty,
    required this.question,
    required this.answer,
  });

  factory InterviewChallenge.fromJson(Map<String, dynamic> json) {
    return InterviewChallenge(
      id: json['id'],
      topic: json['topic'],
      difficulty: json['difficulty'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}