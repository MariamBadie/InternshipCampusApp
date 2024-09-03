import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform

class FirebaseService {
  FirebaseService._privateConstructor();

  static final FirebaseService instance = FirebaseService._privateConstructor();

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb || Platform.isWindows) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDdwt6XiHvlk46DtZXwrl6c4NPXfnw708o",
          authDomain: "campus-app-d0e52.firebaseapp.com",
          databaseURL: "https://campus-app-d0e52-default-rtdb.firebaseio.com",
          projectId: "campus-app-d0e52",
          storageBucket: "campus-app-d0e52.appspot.com",
          messagingSenderId: "709052786972",
          appId: "1:709052786972:web:af8ddea0272df4e0ef32d9",
          measurementId: "G-SDR2E8LC22",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}

final FirebaseService firebaseService = FirebaseService.instance;

void deletePost(String postID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'Posts' collection and delete specific post by sending their IDs
  var usersRef = await firebaseService.firestore.collection('Posts').doc(postID).delete();

  // Perform operations without printing
 return usersRef;

}

void editPost(String postID, String content, String title, String privacy) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Get the current user ID
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Reference the specific post by postID
  DocumentReference postRef = firebaseService.firestore.collection('Posts').doc(postID);

  // Get the post document
  DocumentSnapshot postSnapshot = await postRef.get();

  if (postSnapshot.exists) {
    // Get the userId from the post data
    String postOwnerID = postSnapshot.get('userId');

    if (currentUserID == postOwnerID) {
      // If the current user is the owner of the post, allow editing
      await postRef.update({
        'content': content,
        'title': title,
        'privacy': privacy, // Update the privacy setting
      });
    } else {
      // If the user is not the owner, handle it here
      print("You are not authorized to edit this post.");
    }
  } else {
    print("Post not found.");
  }
}
 reportPost(String postID, {String? reason}) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Get the current user ID
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Reference the specific post by postID
  DocumentReference postRef = firebaseService.firestore.collection('Posts').doc(postID);

  // Get the post document
  DocumentSnapshot postSnapshot = await postRef.get();

  if (postSnapshot.exists) {
    // Add the report to the 'Reports' collection
    await firebaseService.firestore.collection('Reports').add({
      'postId': postID,
      'reporterId': currentUserID,
      'timestamp': FieldValue.serverTimestamp(),
      'reason': reason ?? 'No reason provided', // Optional reason for reporting
    });

    print("Post reported successfully.");
  } else {
    print("Post not found.");
  }
}
void deleteComment(String postID, String commentID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Get the current user ID
  String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Create a reference to the 'Posts' collection
  DocumentReference postRef = firebaseService.firestore.collection('Posts').doc(postID);

  // Create a reference to the specific comment within the post
  DocumentReference commentRef = postRef.collection('Comments').doc(commentID);

  try {
    // Get the comment document
    DocumentSnapshot commentSnapshot = await commentRef.get();

    if (commentSnapshot.exists) {
      // Get the owner ID of the comment
      String commentOwnerID = commentSnapshot.get('authorID');

      if (currentUserID == commentOwnerID) {
        // If the current user is the owner of the comment, delete it
        await commentRef.delete();
        print("Comment deleted successfully.");
      } else {
        // If the user is not the owner, handle it here
        print("You are not authorized to delete this comment.");
      }
    } else {
      print("Comment not found.");
    }
  } catch (e) {
    print("Failed to delete comment: $e");
  }
}
