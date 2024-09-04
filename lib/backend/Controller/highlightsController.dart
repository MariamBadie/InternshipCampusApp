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
    var highlight = Highlights.fromMap(doc.data());
    highlight.id = doc.id; // Add the document ID to the highlight object
    return highlight;
  }).toList();
  
  // Print each highlight with its ID and all data
  for (var highlight in highlightsList) {
    print('Highlight ID: ${highlight.id}');
    print('Data: ${highlight.toString()}'); // Ensure toString() includes all relevant fields
  }
  
  return highlightsList;
}

Future<void> addPostToHighlights(String highlightsId, String postPath) async {
  // Fetch the Highlights from Firestore using the highlightsId
  DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
      .collection('highlights')
      .doc(highlightsId)
      .get();

  if (docSnapshot.exists) {
    // Convert the Firestore document to a Highlights object
    Highlights highlights = Highlights.fromMap(docSnapshot.data()!);

    // Add the post path to the highlights' posts list
    highlights.posts ??= [];
    highlights.posts!.add(postPath);

    // Update Firestore with the modified highlights object
    await FirebaseFirestore.instance
        .collection('highlights')
        .doc(highlightsId)
        .update({
          'posts': highlights.posts, // Store post paths as strings
        });
  } else {
    throw Exception("Highlights with id $highlightsId not found");
  }
}

Future<void> removePostFromHighlightsById(String highlightsId, String postPath) async {
  // Fetch the Highlights from Firestore using the highlightsId
  print('postPath:$postPath');
  DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
      .collection('highlights')
      .doc(highlightsId)
      .get();

  if (docSnapshot.exists) {
    // Convert the Firestore document to a Highlights object
    Highlights highlights = Highlights.fromMap(docSnapshot.data()!);

    // Remove the post path from the list
    highlights.posts?.remove(postPath);

    // If there are no post paths left, delete the highlights document
    if (highlights.posts == null || highlights.posts!.isEmpty) {
      await FirebaseFirestore.instance.collection('highlights').doc(highlightsId).delete();
    } else {
      // Otherwise, update Firestore with the modified posts list
      await FirebaseFirestore.instance
          .collection('highlights')
          .doc(highlightsId)
          .update({
            'posts': highlights.posts, // Store post paths as strings
          });
    }
  } else {
    throw Exception("Highlights with id $highlightsId not found");
  }
}

Future<Post?> getPostFromPath(String postPath) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
        .doc(postPath)
        .get();

    if (docSnapshot.exists) {
      return Post.fromFirestore(docSnapshot.data()!);
    } else {
      throw Exception("Post at path $postPath not found");
    }
  } catch (e) {
    print('Error retrieving post: $e');
    return null;
  }
}
Future<List<Map<String, dynamic>>> fetchHighlightPosts(String highlightID) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> highlightDoc = await FirebaseFirestore.instance
        .collection('highlights')
        .doc(highlightID)
        .get();

    if (highlightDoc.exists) {
      List<dynamic> postRefs = highlightDoc['posts'] ?? [];
      List<Map<String, dynamic>> fetchedPosts = [];

      for (var postRef in postRefs) {
        DocumentReference<Map<String, dynamic>> postDocRef = FirebaseFirestore.instance.doc(postRef as String);
        DocumentSnapshot<Map<String, dynamic>> postDoc = await postDocRef.get();

        if (postDoc.exists) {
          // Add the post ID to the data
          Map<String, dynamic> postData = postDoc.data()!;
          postData['id'] = postDoc.id; // Insert the post ID into the data
          fetchedPosts.add(postData);
        }
      }

      return fetchedPosts;
    } else {
      print('Highlight document with ID $highlightID does not exist.');
      return [];
    }
  } catch (error) {
    print("Error fetching highlight posts: $error");
    return [];
  }
}
