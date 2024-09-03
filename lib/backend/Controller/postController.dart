import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:campus_app/backend/Model/Post.dart';
import 'package:campus_app/backend/Controller/FirebaseService.dart';

class PostController {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final ValueNotifier<List<Post>> posts = ValueNotifier<List<Post>>([]);
  final ValueNotifier<List<Post>> filteredPosts = ValueNotifier<List<Post>>([]);
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String testUserId = "Hussien Test";
  final bool isAdmin = true;

  PostController() {
    _loadPosts();
  }

  bool canEditPost(Post post) {
    return isPostOwner(post) || isAdmin;
  }

  bool isPostOwner(Post post) {
    return post.id == testUserId;
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
    print('Starting uploadAttachment: filePath=$filePath, type=$type');

    try {
      File file = File(filePath);
      if (!await file.exists()) {
        print('File does not exist: $filePath');
        throw Exception('File does not exist');
      }

      String fileName =
          'attachment_${DateTime.now().millisecondsSinceEpoch}${path.extension(filePath)}';
      print('Generated fileName: $fileName');

      Reference storageRef =
          FirebaseStorage.instance.ref('posts_attachments/$fileName');
      print('Storage reference created');

      print('Starting file upload');
      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      print('Upload completed');

      String downloadURL = await snapshot.ref.getDownloadURL();
      print('Download URL obtained: $downloadURL');

      return {'url': downloadURL, 'type': type, 'error': null};
    } catch (e) {
      print('Error in uploadAttachment: $e');
      return {'url': null, 'type': null, 'error': e.toString()};
    }
  }

  Future<void> addPost(Post post) async {
    await _firebaseService.firestore
        .collection('Posts')
        .add(post.toFirestore());
  }

  void _loadPosts() {
    _firebaseService.firestore
        .collection('Posts')
        .snapshots()
        .listen((snapshot) {
      final postsList =
          snapshot.docs.map((doc) => Post.fromFirestore(doc as Map<String, dynamic>)).toList();
      posts.value = postsList;
      filteredPosts.value = postsList;
    });
  }

  void filterPosts(String query) {
    filteredPosts.value = posts.value
        .where((post) =>
            post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> updatePost(Post post) async {
    await _firebaseService.firestore
        .collection('Posts')
        .doc(post.id)
        .update(post.toFirestore());
  }

  Future<void> deletePost(String postId) async {
    await _firebaseService.firestore.collection('Posts').doc(postId).delete();
  }
  
  Future<void> editPost(String postId, String updatedContent, String updatedTitle) async {
  Map<String, dynamic> updatedData = {
    'content': updatedContent,
    'title': updatedTitle,
  };

  await _firebaseService.firestore.collection('Posts').doc(postId).update(updatedData);
}


  

  Future<void> addComment(String postId, Comment comment) async {
    await _firebaseService.firestore.collection('Posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([comment.toMap()])
    });
  }

  Future<File?> downloadAttachment(
      String downloadURL, String attachmentType) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String fileName =
          'attachment_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(attachmentType)}';
      final File tempFile = File('${tempDir.path}/$fileName');

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

  Future<String> downloadPostContent(Post post) async {
    try {
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }

      String fileName = '${post.content.replaceAll(' ', '_')}_${post.id}.txt';
      String filePath = '${directory!.path}/$fileName';
      File file = File(filePath);

      String content = 'User: ${post.username}\n'
          'Content:\n${post.content}\n\n'
          'Comments:\n${post.comments.map((c) => '- ${c.username}: ${c.content}').join('\n')}';

      

      await file.writeAsString(content);
      return 'Post content downloaded successfully: $filePath';
    } catch (e) {
      return 'Error downloading post content: $e';
    }
  }

  void dispose() {
    posts.dispose();
    filteredPosts.dispose();
  }
}
