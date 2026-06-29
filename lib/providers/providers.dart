import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_boost/models/learning_card.dart';
import 'package:mind_boost/models/note.dart';
import 'package:mind_boost/models/reminder_settings.dart';
import 'package:mind_boost/repositories/card_repository.dart';
import 'package:mind_boost/repositories/note_repository.dart';
import 'package:mind_boost/services/notification_service.dart';
import 'package:mind_boost/services/storage_service.dart';

// --- Repositories Providers ---
final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => CardRepository(),
);
final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(),
);

// --- Theme Mode Provider ---
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier()
    : super(StorageService.isDarkMode() ? ThemeMode.dark : ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      StorageService.setDarkMode(true);
    } else {
      state = ThemeMode.light;
      StorageService.setDarkMode(false);
    }
  }
}

final themeModeNotifierProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
      (ref) => ThemeModeNotifier(),
    );

// --- Selected Topics Provider ---
class SelectedTopicsNotifier extends StateNotifier<List<String>> {
  SelectedTopicsNotifier() : super(StorageService.getSelectedTopics());

  void setTopics(List<String> topics) {
    state = topics;
    StorageService.setSelectedTopics(topics);
  }

  void toggleTopic(String topic) {
    if (state.contains(topic)) {
      state = state.where((t) => t != topic).toList();
    } else {
      state = [...state, topic];
    }
    StorageService.setSelectedTopics(state);
  }
}

final selectedTopicsNotifierProvider =
    StateNotifierProvider<SelectedTopicsNotifier, List<String>>(
      (ref) => SelectedTopicsNotifier(),
    );

// --- OpenAI Key Provider ---
class OpenAiKeyNotifier extends StateNotifier<String> {
  OpenAiKeyNotifier() : super(StorageService.getOpenAiApiKey());

  void setKey(String key) {
    state = key;
    StorageService.setOpenAiApiKey(key);
  }
}

final openAiKeyNotifierProvider =
    StateNotifierProvider<OpenAiKeyNotifier, String>(
      (ref) => OpenAiKeyNotifier(),
    );

// --- Daily Streak Provider ---
class StreakNotifier extends StateNotifier<int> {
  StreakNotifier() : super(StorageService.getStreak()) {
    _checkStreakValidity();
  }

  void _checkStreakValidity() {
    final lastRead = StorageService.getLastReadDate();
    if (lastRead.isEmpty) return;

    final lastReadDate = DateTime.parse(lastRead);
    final now = DateTime.now();
    final difference = DateTime(now.year, now.month, now.day)
        .difference(
          DateTime(lastReadDate.year, lastReadDate.month, lastReadDate.day),
        )
        .inDays;

    if (difference > 1) {
      // Streak broken
      state = 0;
      StorageService.setStreak(0);
    }
  }

  void markCardRead() {
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();
    final lastRead = StorageService.getLastReadDate();

    if (lastRead != todayStr) {
      state = state + 1;
      StorageService.setStreak(state);
      StorageService.setLastReadDate(todayStr);
    }
  }
}

final streakNotifierProvider = StateNotifierProvider<StreakNotifier, int>(
  (ref) => StreakNotifier(),
);

// --- Learning Card Generation Provider ---
class CardNotifier extends StateNotifier<AsyncValue<LearningCard?>> {
  final CardRepository _repository;
  CardNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> fetchCard(String topic, {bool forceGenerate = false}) async {
    state = const AsyncValue.loading();
    try {
      if (!forceGenerate) {
        // First check cached card of today
        final cached = _repository.getCachedCards();
        final today = DateTime.now();
        final todayCards = cached
            .where(
              (c) =>
                  c.topic.toLowerCase() == topic.toLowerCase() &&
                  c.generatedAt.year == today.year &&
                  c.generatedAt.month == today.month &&
                  c.generatedAt.day == today.day,
            )
            .toList();

        if (todayCards.isNotEmpty) {
          state = AsyncValue.data(todayCards.first);
          return;
        }
      }

      // Generate a new card
      final card = await _repository.getCardForTopic(topic);
      state = AsyncValue.data(card);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final cardNotifierProvider =
    StateNotifierProvider<CardNotifier, AsyncValue<LearningCard?>>((ref) {
      final repo = ref.watch(cardRepositoryProvider);
      return CardNotifier(repo);
    });

// --- Notes Management Provider ---
class NotesNotifier extends StateNotifier<List<Note>> {
  final NoteRepository _repository;
  NotesNotifier(this._repository) : super([]) {
    loadNotes();
  }

  void loadNotes() {
    final list = _repository.getNotes();
    // Sort pinned notes first, then latest first
    list.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    state = list;
  }

  Future<void> addNote(String title, String content, String topic) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      topic: topic,
      createdAt: DateTime.now(),
    );
    await _repository.saveNote(note);
    loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _repository.saveNote(note);
    loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    loadNotes();
  }

  Future<void> togglePin(String id) async {
    final note = state.firstWhere((n) => n.id == id);
    final updated = note.copyWith(isPinned: !note.isPinned);
    await _repository.saveNote(updated);
    loadNotes();
  }
}

final notesNotifierProvider = StateNotifierProvider<NotesNotifier, List<Note>>((
  ref,
) {
  final repo = ref.watch(noteRepositoryProvider);
  return NotesNotifier(repo);
});

// --- Reminder Settings Provider ---
class ReminderSettingsNotifier extends StateNotifier<ReminderSettings> {
  ReminderSettingsNotifier()
    : super(
        ReminderSettings(
          isEnabled: StorageService.isNotificationEnabled(),
          frequency: StorageService.getNotificationFrequency(),
          hour: StorageService.getCustomNotificationTime()['hour']!,
          minute: StorageService.getCustomNotificationTime()['minute']!,
        ),
      );

  Future<void> toggleEnabled(bool enabled) async {
    state = state.copyWith(isEnabled: enabled);
    await StorageService.setNotificationEnabled(enabled);
    await _syncNotifications();
  }

  Future<void> setFrequency(String freq) async {
    state = state.copyWith(frequency: freq);
    await StorageService.setNotificationFrequency(freq);
    await _syncNotifications();
  }

  Future<void> setCustomTime(int hour, int minute) async {
    state = state.copyWith(hour: hour, minute: minute);
    await StorageService.setCustomNotificationTime(hour, minute);
    await _syncNotifications();
  }

  Future<void> _syncNotifications() async {
    if (state.isEnabled) {
      await NotificationService.requestPermissions();
      await NotificationService.scheduleReminders(
        frequency: state.frequency,
        customHour: state.hour,
        customMinute: state.minute,
      );
    } else {
      await NotificationService.cancelAll();
    }
  }
}

final reminderSettingsNotifierProvider =
    StateNotifierProvider<ReminderSettingsNotifier, ReminderSettings>(
      (ref) => ReminderSettingsNotifier(),
    );
