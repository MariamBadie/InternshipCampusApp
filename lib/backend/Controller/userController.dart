
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Return the user
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error signing in: ${e.message}");
      // Handle errors (e.g., show an error message to the user)
      return null;
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error signing out: $e");
      // Handle errors (e.g., show an error message to the user)
    }
  }
}

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

Future<void> signIn(String email ,String password) async {

await firebaseService.initialize();


}

void deleteAccount(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();
  var userSnapshot =
      await firebaseService.firestore.collection('User').doc(userID).delete();
  return;
}

void removeFromFavorites(String userID, String postID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the specific document in the 'Posts' collection
  DocumentReference<Map<String, dynamic>> postRef =
      firebaseService.firestore.doc('/Posts/$postID');

  // Create a reference to the 'User' collection and filter the document
  var querySnapshot = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();

  for (var doc in querySnapshot.docs) {
    var favorites = (doc.data()['favorites'] as List<dynamic>?) ?? [];
    var updatedFavorites = favorites.where((fav) {
      var map = fav as Map<String, dynamic>;
      return map['post'] != postRef;
    }).toList();

    await doc.reference.update({
      'favorites': updatedFavorites,
    });
  }
}


void addToFavorites(String userID, String postID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the specific post
  DocumentReference<Map<String, dynamic>> postRef =
      firebaseService.firestore.doc('/Posts/$postID');

  // Create a reference to the 'User' collection and filter the document
  var querySnapshot = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({
      'favorites': FieldValue.arrayUnion([
        {
          'post': postRef,
          'timestamp': Timestamp.now(),
        }
      ]),
    });
  }
}


void clearMyFavorites(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'User' collection and filter the document
  var querySnapshot = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({
      'favorites': [],
    });
  }
}


Future<List<DocumentReference<Map<String, dynamic>>>> getListFavorites(
    String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'User' collection
  var userSnapshot =
      await firebaseService.firestore.collection('User').doc(userID).get();

  // Check if the document exists
  if (userSnapshot.exists) {
    var favorites = userSnapshot.data()?['favorites'] as List<dynamic>? ?? [];
    // Return the list of post references from the favorites
    return favorites
        .map((item) => (item as Map<String, dynamic>)['post'] as DocumentReference<Map<String, dynamic>>)
        .toList();
  } else {
    // Return an empty list if the document doesn't exist
    return [];
  }
}
Future<List> getFavoritesPostData(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Retrieve the list of favorite posts
  var favoritesList = await getListFavorites(userID);

  // List to store the post ID, title, content, and timestamp
  var favoritesPostData = [];
  // Loop through the list of post references and fetch their data
  for (var postRef in favoritesList) {
    var postSnapshot = await postRef.get();
    // Check if the post exists and add the post ID, title, content to the list
    if (postSnapshot.exists) {
      var postData = postSnapshot.data() ?? {};
      var postID = postRef.id;
      var title = postData['title'] ?? '';
      var content = postData['content'] ?? '';
      var isConfession = postData['isConfession'] ?? '';

      // Retrieve the favorites array from the user document
      var userSnapshot = await firebaseService.firestore.collection('User').doc(userID).get();
      var favorites = List<Map<String, dynamic>>.from(userSnapshot.data()?['favorites'] ?? []);

      // Find the corresponding favorite entry
      for (var favorite in favorites) {
        var postReference = favorite['post'] as DocumentReference<Map<String, dynamic>>?;
        var timestamp = favorite['timestamp'] as Timestamp?;

        if (postReference != null && timestamp != null && postReference==postRef) {
          favoritesPostData.add(
            [postID, title, content,isConfession, timestamp.toDate()]
          );
        }
      }
    }
  }

  print("favoritesPostData: $favoritesPostData");
  // Return the list of post ID, title, content, and timestamp strings
  return favoritesPostData;
}


Future<List<DocumentReference<Map<String, dynamic>>>> getListArchived(
    String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'User' collection
  var userSnapshot =
      await firebaseService.firestore.collection('User').doc(userID).get();

  // Check if the document exists
  if (userSnapshot.exists) {
    // Return the list of archived document references
    return List<DocumentReference<Map<String, dynamic>>>.from(
        userSnapshot.data()?['archived'] ?? []);
  } else {
    // Return an empty list if the document doesn't exist
    return [];
  }
}

Future<List<String>> getArchivedPostData(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Retrieve the list of archived document references
  var archivedList = await getListArchived(userID);

  // List to store the titles and contents
  List<String> archivedPostData = [];

  // Loop through the list of archived references and fetch their data
  for (var postRef in archivedList) {
    var postSnapshot = await postRef.get();

    // Check if the post exists and add the title and content to the list
    if (postSnapshot.exists) {
      archivedPostData.add(
        '${postSnapshot.data()?['title'] ?? ''},${postSnapshot.data()?['content'] ?? ''},${postSnapshot.id}'
      );
    }
  }
  print('archivedPostData:$archivedPostData');
  // Return the list of title and content strings
  return archivedPostData;
}


void removeFromArchived(String postID, String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the specific document in the 'Posts' collection
  DocumentReference<Map<String, dynamic>> postRef =
      firebaseService.firestore.doc('/Posts/$postID');

  // Create a reference to the 'User' collection and filter the document
  var querySnapshot = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .where('archived', arrayContains: postRef)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({
      'archived': FieldValue.arrayRemove([postRef])
    });
  }
}

void addToArchived(String postID, String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'users' collection
  var usersRef = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();
  DocumentReference<Map<String, dynamic>> postRef =
      firebaseService.firestore.doc('/Posts/$postID');

  // Perform operations without printing
  for (var doc in usersRef.docs) {
    await doc.reference.update({
      'archived': FieldValue.arrayUnion([postRef])
    });
  } // Example: Further processing of the snapshot can be done here
}

Future<List<Map<String, dynamic>>> viewBlockedAccounts(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Retrieve the user document
  var userSnapshot = await firebaseService.firestore.collection('User').doc(userID).get();

  if (userSnapshot.exists) {
    // Retrieve the list of blocked references
    List<DocumentReference<Map<String, dynamic>>> blockedAccounts =
        List<DocumentReference<Map<String, dynamic>>>.from(
            userSnapshot.data()?['blocked'] ?? []);

    List<Map<String, dynamic>> blockedAccountData = [];
    for (var blockedRef in blockedAccounts) {
      var blockedSnapshot = await blockedRef.get();
      if (blockedSnapshot.exists) {
        blockedAccountData.add({
          'id': blockedSnapshot.id,
          'data': blockedSnapshot.data(),
        });
      }
    }
    return blockedAccountData;
  } else {
    return [];
  }
}


Future<void> removeFromBlockedAccounts(String userID, String blockedUserID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Reference the user document in Firestore
  var userRef = firebaseService.firestore.collection('User').doc(userID);

  // Reference the blocked user using the blockedUserID
  DocumentReference<Map<String, dynamic>> blockedUserRef =
      firebaseService.firestore.collection('User').doc(blockedUserID);

  // Remove the blocked user reference from the 'blocked' array
  await userRef.update({
    'blocked': FieldValue.arrayRemove([blockedUserRef])
  });
}


