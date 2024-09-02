
import 'package:campus_app/backend/Model/Highlights.dart';
import 'package:campus_app/backend/Model/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:flutter/material.dart';

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

Future<void> createHighlights(Highlights highlights) async {
  await firebaseService.initialize();
  try {
    await FirebaseFirestore.instance.collection('highlights').add(highlights.toMap());
    print('Highlights created successfully');
  } catch (e) {
    print('Failed to create Highlights: $e');
  }
}

Future<List<Highlights>> getHighlights(String userId) async {
  // Query Firestore to get all highlights for a specific user
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('highlights')
      .where('userID', isEqualTo: userId)
      .get();

  // Map the Firestore documents to a list of Highlights objects
  List<Highlights> highlightsList = querySnapshot.docs.map((doc) {
    return Highlights.fromMap(doc.data());
  }).toList();
  print("highlightsList: $highlightsList");
  return highlightsList;
}

Future<void> addPostToHighlights(String highlightsId, Post post) async {
  // Fetch the Highlights from Firestore using the highlightsId
  DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
      .collection('highlights')
      .doc(highlightsId)
      .get();

  if (docSnapshot.exists) {
    // Convert the Firestore document to a Highlights object
    Highlights highlights = Highlights.fromMap(docSnapshot.data()!);

    // Add the post to the highlights' post list
    if (highlights.posts == null) {
      highlights.posts = [];
    }
    highlights.posts!.add(post);

    // Update Firestore with the modified highlights object
    await FirebaseFirestore.instance
        .collection('highlights')
        .doc(highlightsId)
        .update({
          'posts': highlights.posts!.map((p) => p.toMap()).toList(),
        });
  } else {
    throw Exception("Highlights with id $highlightsId not found");
  }
}

Future<void> removePostFromHighlightsById(String highlightsId, Post post) async {
  // Fetch the Highlights from Firestore using the highlightsId
  DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
      .collection('highlights')
      .doc(highlightsId)
      .get();

  if (docSnapshot.exists) {
    // Convert the Firestore document to a Highlights object
    Highlights highlights = Highlights.fromMap(docSnapshot.data()!);

    // Remove the post from the list
    highlights.posts?.removeWhere((element) => element.id == post.id);

    // If there are no posts left, delete the highlights document
    if (highlights.posts == null || highlights.posts!.isEmpty) {
      await deleteHighlights(highlightsId);
    } else {
      // Otherwise, update Firestore with the modified posts list
      await FirebaseFirestore.instance
          .collection('highlights')
          .doc(highlightsId)
          .update({
            'posts': highlights.posts!.map((p) => p.toMap()).toList(),
          });
    }
  } else {
    throw Exception("Highlights with id $highlightsId not found");
  }
}

Future<void> deleteHighlights(String highlightsId) async {
  await FirebaseFirestore.instance
      .collection('highlights')
      .doc(highlightsId)
      .delete();
}
