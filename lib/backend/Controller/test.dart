import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  retrieveData();
}

void retrieveData() async {
  // List of collection names
  List<String> collections = [
    'Comments',
    'Community',
    'Course',
    'Expense',
    'Feedback',
    'FriendRequests',
    'Friends',
    'LostAndFound',
    'Membership',
    'Notification',
    'Outlet',
    'Posts',
    'Rating',
    'User'
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (String collection in collections) {
    // Fetch data from each collection
    QuerySnapshot snapshot = await firestore.collection(collection).get();

    // Print the data retrieved from each document in the collection
    snapshot.docs.forEach((doc) {
      print('Collection: $collection, Document ID: ${doc.id}, Data: ${doc.data()}');
    });
  }
}