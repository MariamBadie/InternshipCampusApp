

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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

void deleteAccount(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  var userSnapshot =
      await firebaseService.firestore.collection('User').doc(userID).delete();
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
      .where('favorites', arrayContains: postRef)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.update({
      'favorites': FieldValue.arrayRemove([postRef])
    });
  }
}

void addToFavorites(String userID, String postID) async {
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
      'favorites': FieldValue.arrayUnion([postRef])
    });
  } // Example: Further processing of the snapshot can be done here
}

void clearMyFavorites(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'users' collection
  var usersRef = await firebaseService.firestore
      .collection('User')
      .where(FieldPath.documentId, isEqualTo: userID)
      .get();
  // Perform operations without printing
  for (var doc in usersRef.docs) {
    await doc.reference.update({'favorites': []});
  } // Example: Further processing of the snapshot can be done here
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

void getArchivedPostData(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Retrieve the list of archived document references
  var archivedList = await getListArchived(userID);

  // Loop through the list of archived references and fetch their data
  for (var postRef in archivedList) {
    var postSnapshot = await postRef.get();

    // Print the data of each archived post
    if (postSnapshot.exists) {
      print(postSnapshot.data());
    } else {
      print('Archived post does not exist.');
    }
  }
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

void viewBlockedAccounts(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Retrieve the user document
  var userSnapshot = await firebaseService.firestore.collection('User').doc(userID).get();

  if (userSnapshot.exists) {
    // Retrieve the list of blocked references
    List<DocumentReference<Map<String, dynamic>>> blockedAccounts =
        List<DocumentReference<Map<String, dynamic>>>.from(
            userSnapshot.data()?['blocked'] ?? []);

    print("Blocked Accounts:");
    for (var blockedRef in blockedAccounts) {
      var blockedSnapshot = await blockedRef.get();
      if (blockedSnapshot.exists) {
        print('Blocked User ID: ${blockedSnapshot.id}');
        print('Blocked User Data: ${blockedSnapshot.data()}');
      } else {
        print('Blocked user does not exist.');
      }
    }
  } else {
    print("User does not exist.");
  }
}


void removeFromBlockedAccounts(String userID, String blockedUserID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'User' collection
  var userRef = firebaseService.firestore.collection('User').doc(userID);

  // Create a reference to the blocked user
  DocumentReference<Map<String, dynamic>> blockedUserRef =
      firebaseService.firestore.doc('/User/$blockedUserID');

  // Perform the removal of the blocked account
  await userRef.update({
    'blocked': FieldValue.arrayRemove([blockedUserRef])
  });
}
