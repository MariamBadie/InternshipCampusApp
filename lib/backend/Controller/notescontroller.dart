import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/backend/Controller/FirebaseService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NotesController {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>([]);
  final ValueNotifier<List<Note>> filteredNotes = ValueNotifier<List<Note>>([]);
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<String?> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }

  Future<String?> uploadPDF(String filePath) async {
    try {
      File file = File(filePath);
      String fileName = 'note_${DateTime.now().millisecondsSinceEpoch}.pdf';

      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('notes_attachments/$fileName')
          .putFile(file);

      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading PDF: $e');
      return null;
    }
  }

  Future<File?> downloadPDF(String downloadURL) async {
    try {
      // Create a temporary file
      final Directory tempDir = Directory.systemTemp;
      final File tempFile = File(
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');

      // Download the file from Firebase Storage
      await _storage.refFromURL(downloadURL).writeToFile(tempFile);

      return tempFile;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  void dispose() {
    notes.dispose();
    filteredNotes.dispose();
  }

  Future<String> downloadNote(Note note) async {
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

      String content = 'Title: ${note.title}\n'
          'Number: ${note.number}\n\n'
          'Content:\n${note.content}\n\n'
          'Comments:\n${note.comments.map((c) => '- ${c.authorName}: ${c.text}').join('\n')}';

      if (note.attachmentUrl != null) {
        content += '\n\nAttachment: ${note.attachmentUrl}';
      }

      await file.writeAsString(content);
      return 'Note downloaded successfully: $filePath';
    } catch (e) {
      return 'Error downloading note: $e';
    }
  }
}
