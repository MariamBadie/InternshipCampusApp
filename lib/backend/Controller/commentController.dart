
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


Future<List> getListComments(
    String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Create a reference to the 'Comments' collection
  var userSnapshot = await firebaseService.firestore.collection('Comments').where("autherID", isEqualTo: "/User/$userID").get();
  var listofComments =[];
  // Check if the document exists
  for (var doc in userSnapshot.docs) {
  var timestamp = (doc.data()['createdAt'])as Timestamp?;
  var content = (doc.data()['content']);
  listofComments.add([timestamp?.toDate(),content]);
 }
 print(listofComments);
 return listofComments;
}