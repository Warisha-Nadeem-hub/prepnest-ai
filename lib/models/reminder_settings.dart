class ReminderSettings {
  final bool isEnabled;
  final String frequency;
  final int hour;
  final int minute;

  ReminderSettings({
    required this.isEnabled,
    required this.frequency,
    required this.hour,
    required this.minute,
  });

  ReminderSettings copyWith({
    bool? isEnabled,
    String? frequency,
    int? hour,
    int? minute,
  }) {
    return ReminderSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      frequency: frequency ?? this.frequency,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}
