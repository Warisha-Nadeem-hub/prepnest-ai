import 'package:hive_flutter/hive_flutter.dart';
import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/models/note.dart';

class StorageService {
  static const String cardsBoxName = 'learning_cards';
  static const String notesBoxName = 'notes';
  static const String settingsBoxName = 'settings';

  static late Box _cardsBox;
  static late Box _notesBox;
  static late Box _settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _cardsBox = await Hive.openBox(cardsBoxName);
    _notesBox = await Hive.openBox(notesBoxName);
    _settingsBox = await Hive.openBox(settingsBoxName);
  }

  // --- Learning Cards Operations ---
  static List<LearningCard> getSavedCards() {
    try {
      return _cardsBox.values
          .map(
            (item) =>
                LearningCard.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveCard(LearningCard card) async {
    await _cardsBox.put(card.id, card.toJson());
  }

  static Future<void> deleteCard(String id) async {
    await _cardsBox.delete(id);
  }

  static Future<void> clearCards() async {
    await _cardsBox.clear();
  }

  // --- Notes Operations ---
  static List<Note> getNotes() {
    try {
      return _notesBox.values
          .map((item) => Note.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveNote(Note note) async {
    await _notesBox.put(note.id, note.toJson());
  }

  static Future<void> deleteNote(String id) async {
    await _notesBox.delete(id);
  }

  static Future<void> clearNotes() async {
    await _notesBox.clear();
  }

  // --- Settings & App State Operations ---
  static Future<void> setOpenAiApiKey(String key) async {
    await _settingsBox.put('openai_api_key', key);
  }

  static String getOpenAiApiKey() {
    return _settingsBox.get('openai_api_key', defaultValue: '') as String;
  }

  static Future<void> setSelectedTopics(List<String> topics) async {
    await _settingsBox.put('selected_topics', topics);
  }

  static List<String> getSelectedTopics() {
    final List<dynamic>? list =
        _settingsBox.get('selected_topics') as List<dynamic>?;
    return list?.map((e) => e as String).toList() ?? [];
  }

  static Future<void> setStreak(int count) async {
    await _settingsBox.put('streak_count', count);
  }

  static int getStreak() {
    return _settingsBox.get('streak_count', defaultValue: 0) as int;
  }

  static Future<void> setLastReadDate(String dateStr) async {
    await _settingsBox.put('last_read_date', dateStr);
  }

  static String getLastReadDate() {
    return _settingsBox.get('last_read_date', defaultValue: '') as String;
  }

  static Future<void> setDarkMode(bool isDark) async {
    await _settingsBox.put('dark_mode', isDark);
  }

  static bool isDarkMode() {
    return _settingsBox.get('dark_mode', defaultValue: false) as bool;
  }

  static Future<void> setOnboarded(bool value) async {
    await _settingsBox.put('onboarded', value);
  }

  static bool isOnboarded() {
    return _settingsBox.get('onboarded', defaultValue: false) as bool;
  }

  static Future<void> setNotificationEnabled(bool value) async {
    await _settingsBox.put('notifications_enabled', value);
  }

  static bool isNotificationEnabled() {
    return _settingsBox.get('notifications_enabled', defaultValue: false)
        as bool;
  }

  static Future<void> setNotificationFrequency(String freq) async {
    await _settingsBox.put('notification_frequency', freq);
  }

  static String getNotificationFrequency() {
    return _settingsBox.get(
          'notification_frequency',
          defaultValue: 'Once daily',
        )
        as String;
  }

  static Future<void> setCustomNotificationTime(int hour, int minute) async {
    await _settingsBox.put('custom_notification_hour', hour);
    await _settingsBox.put('custom_notification_minute', minute);
  }

  static Map<String, int> getCustomNotificationTime() {
    final hour =
        _settingsBox.get('custom_notification_hour', defaultValue: 9) as int;
    final minute =
        _settingsBox.get('custom_notification_minute', defaultValue: 0) as int;
    return {'hour': hour, 'minute': minute};
  }

  static Future<void> clearAll() async {
    await _cardsBox.clear();
    await _notesBox.clear();
    await _settingsBox.clear();
  }
}
