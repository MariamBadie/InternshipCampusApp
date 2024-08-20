import 'package:campus_app/backend/Model/FriendRequests.dart';
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

// Method to get all Friend Requests for a user
Future<List<FriendRequests>> getAllFriendRequests(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Fetch all Friend Requests for the specified user
  QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseService.firestore
      .collection('FriendRequests')
      .where('receiverID', isEqualTo: firebaseService.firestore.doc('User/$userID'))
      .get();

  // Map each document to a Friend Request object
  return snapshot.docs.map((doc) {
    return FriendRequests.fromMap(doc.id, doc.data());
  }).toList();
}

// Method to delete a Friend Request
Future<void> deleteFriendRequestUsingID(String requestID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Delete the expense document
  await firebaseService.firestore.collection('FriendRequests').doc(requestID).delete();

}

// Method to delete a Friend Request
Future<void> deleteFriendRequest(String senderID, String receiverID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Query to find the specific friend request to delete
  QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseService.firestore
      .collection('FriendRequests')
      .where('senderID', isEqualTo: firebaseService.firestore.doc('User/$senderID'))
      .where('receiverID', isEqualTo: firebaseService.firestore.doc('User/$receiverID'))
      .get();

  // Delete each document found by the query
  for (var doc in snapshot.docs) {
    await firebaseService.firestore.collection('FriendRequests').doc(doc.id).delete();
  }
}

// Method to clear all Friend Requests for a user
Future<void> clearAllFriendRequests(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Query to get all friend requests where the receiverID matches the userID
  QuerySnapshot<Map<String, dynamic>> snapshot = await firebaseService.firestore
      .collection('FriendRequests')
      .where('receiverID', isEqualTo: firebaseService.firestore.doc('User/$userID'))
      .get();

  // Delete each document found by the query
  for (var doc in snapshot.docs) {
    await firebaseService.firestore.collection('FriendRequests').doc(doc.id).delete();
  }
}
