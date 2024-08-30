

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io'; // For Platform
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/backend/Model/Reminder.dart';
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


Future<void> createReminder(Reminder reminder) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').add(reminder.toMap());
    print('Reminder created successfully');
  } catch (e) {
    print('Failed to create reminder: $e');
  }
}

Future<void> deleteReminder(String reminderId) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').doc(reminderId).delete();
    print('Reminder deleted successfully');
  } catch (e) {
    print('Failed to delete reminder: $e');
  }
}

Future<void> toggleReminder(String reminderId, bool newStatus) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').doc(reminderId).update({'onOff': newStatus});
    print('Reminder updated successfully');
  } catch (e) {
    print('Failed to update reminder: $e');
  }
}

Future<void> changeReminderTime(String reminderId, Timestamp newTime) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').doc(reminderId).update({'time': newTime});
    print('Reminder time updated successfully');
  } catch (e) {
    print('Failed to update reminder time: $e');
  }
}

Future<void> changeReminderContent(String reminderId, String newContent) async {
  try {
    await FirebaseFirestore.instance.collection('reminders').doc(reminderId).update({'content': newContent});
    print('Reminder content updated successfully');
  } catch (e) {
    print('Failed to update reminder content: $e');
  }
}

// New function to view all reminders based on userID
Future<List<Reminder>> viewRemindersByUser(String userID) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('userID', isEqualTo: userID)
        .get();

    List<Reminder> reminders = querySnapshot.docs
        .map((doc) => Reminder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    return reminders;
  } catch (e) {
    print('Failed to retrieve reminders: $e');
    return [];
  }
}
