import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_ease/models/note.dart';

class NoteService {
  String _keyFor(String username) => 'notes_$username';

  Future<List<Note>> getNotes(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(username));
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Note.fromJson(e)).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveNote(String username, Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes(username);
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      notes[index] = note;
    } else {
      notes.add(note);
    }
    await prefs.setString(
        _keyFor(username),
        jsonEncode(notes.map((n) => n.toJson()).toList()));
  }

  Future<void> deleteNote(String username, String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes(username);
    notes.removeWhere((n) => n.id == noteId);
    await prefs.setString(
        _keyFor(username),
        jsonEncode(notes.map((n) => n.toJson()).toList()));
  }
}