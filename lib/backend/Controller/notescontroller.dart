import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/backend/Controller/FirebaseService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotesController {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>([]);
  final ValueNotifier<List<Note>> filteredNotes = ValueNotifier<List<Note>>([]);
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotesController() {
    _loadNotes();
  }
  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }

  Future<String?> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  Future<String?> captureImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  Future<Map<String, String?>> uploadAttachment(
      String filePath, String type) async {
    try {
      File file = File(filePath);
      String fileName =
          'attachment_${DateTime.now().millisecondsSinceEpoch}${type == 'image' ? '.jpg' : ''}';

      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('notes_attachments/$fileName')
          .putFile(file);

      String downloadURL = await snapshot.ref.getDownloadURL();
      return {'url': downloadURL, 'type': type};
    } catch (e) {
      print('Error uploading attachment: $e');
      return {'url': null, 'type': null};
    }
  }

  Future<void> addNote(Note note) async {
    await _firebaseService.firestore
        .collection('notes')
        .add(note.toFirestore());
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

  Future<File?> downloadAttachment(
      String downloadURL, String attachmentType) async {
    try {
      // Create a temporary file
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'attachment_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(attachmentType)}';
      final File tempFile = File('${tempDir.path}/$fileName');

      // Download the file from Firebase Storage
      final http.Response response = await http.get(Uri.parse(downloadURL));
      await tempFile.writeAsBytes(response.bodyBytes);

      return tempFile;
    } catch (e) {
      print('Error downloading attachment: $e');
      return null;
    }
  }

  String _getFileExtension(String attachmentType) {
    switch (attachmentType) {
      case 'image':
        return '.jpg';
      case 'pdf':
        return '.pdf';
      default:
        return '';
    }
  }

  Future<String> downloadNoteContent(Note note) async {
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
        content +=
            '\n\nAttachment: ${note.attachmentUrl} (Type: ${note.attachmentType})';
      }

      await file.writeAsString(content);
      return 'Note content downloaded successfully: $filePath';
    } catch (e) {
      return 'Error downloading note content: $e';
    }
  }

  void dispose() {
    notes.dispose();
    filteredNotes.dispose();
  }
}
