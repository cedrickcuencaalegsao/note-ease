import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../../models/note.dart';

class NoteService {
  final _db = FirebaseDatabase.instance.ref();

  DatabaseReference _noteRef(String uid) => _db.child('notes/$uid');

  Future<List<Note>> getNotes(String uid) async {
    try {
      final snapshot = await _noteRef(uid).get();
      if (!snapshot.exists) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final notes = data.entries.map((e) {
        return Note.fromJson(Map<String, dynamic>.from(e.value as Map));
      }).toList();

      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      debugPrint('Errors: $e');
      return [];
    }
  }

  Future<void> saveNote(String uid, Note note) async {
    await _noteRef(uid).child(note.id).set(note.toJson());
  }

  Future<void> deleteNote(String uid, String noteId) async{
    await _noteRef(uid).child(noteId).remove();
  }
}
