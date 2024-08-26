import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/backend/Controller/FirebaseService.dart';

class NotesController {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>([]);
  final ValueNotifier<List<Note>> filteredNotes = ValueNotifier<List<Note>>([]);

  NotesController() {
    _loadNotes();
  }

  void _loadNotes() {
    _firebaseService.firestore
        .collection('notes')
        .snapshots()
        .listen((snapshot) {
      final notesList =
          snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      notes.value = notesList;
      filteredNotes.value = notesList;
    });
  }

  void filterNotes(String query) {
    filteredNotes.value = notes.value
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.number.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> addNote(Note note) async {
    await _firebaseService.firestore
        .collection('notes')
        .add(note.toFirestore());
  }

  Future<void> updateNote(Note note) async {
    await _firebaseService.firestore
        .collection('notes')
        .doc(note.id)
        .update(note.toFirestore());
  }

  Future<void> deleteNote(String noteId) async {
    await _firebaseService.firestore.collection('notes').doc(noteId).delete();
  }

  Future<void> addComment(String noteId, Comment comment) async {
    await _firebaseService.firestore.collection('notes').doc(noteId).update({
      'comments': FieldValue.arrayUnion([comment.toMap()])
    });
  }

  Future<String> downloadNote(Note note) async {
    if (kIsWeb) {
      return 'Download not supported on web platform';
    }
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
    try {
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }
      String fileName = '${note.title.replaceAll(' ', '_')}_${note.number}.txt';
      String filePath = '${directory!.path}/$fileName';
      File file = File(filePath);
      await file.writeAsString('Title: ${note.title}\n'
          'Number: ${note.number}\n\n'
          'Content:\n${note.content}\n\n'
          'Comments:\n${note.comments.map((c) => '- ${c.authorName}: ${c.text}').join('\n')}');
      return 'Note downloaded successfully: $filePath';
    } catch (e) {
      return 'Error downloading note: $e';
    }
  }

  void dispose() {
    notes.dispose();
    filteredNotes.dispose();
  }
}
