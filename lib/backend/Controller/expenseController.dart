import 'package:campus_app/backend/Model/Expense.dart';
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

// Method to add an expense
Future<void> addExpense(Expense expense, String userID) async {
  await firebaseService.initialize();

  // Convert the authorID to a Firestore reference
  Map<String, dynamic> expenseData = expense.toMap();
  expenseData['authorID'] = firebaseService.firestore.doc('User/$userID');

  // Add the expense to Firestore with an auto-generated ID
  await firebaseService.firestore.collection('Expense').add(expenseData);
}

// Method to delete an expense
Future<void> deleteExpense(String expenseID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Delete the expense document
  await firebaseService.firestore.collection('Expense').doc(expenseID).delete();
}

// Method to get all expenses for a user
Future<List<Expense>> getAllExpenses(String userID) async {
  // Ensure Firebase is initialized
  await firebaseService.initialize();

  // Fetch all expenses for the specified user
  QuerySnapshot snapshot = await firebaseService.firestore
      .collection('Expense')
      .where('authorID', isEqualTo: firebaseService.firestore.doc('User/$userID'))
      .get();

  // Map each document to an Expense object
  return snapshot.docs.map((doc) {
    return Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }).toList();
}
