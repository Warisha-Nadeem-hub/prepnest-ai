import 'package:mind_boost/models/note.dart';
import 'package:mind_boost/services/storage_service.dart';

class NoteRepository {
  List<Note> getNotes() {
    return StorageService.getNotes();
  }

  Future<void> saveNote(Note note) async {
    await StorageService.saveNote(note);
  }

  Future<void> deleteNote(String id) async {
    await StorageService.deleteNote(id);
  }

  Future<void> clearAll() async {
    await StorageService.clearNotes();
  }
}
