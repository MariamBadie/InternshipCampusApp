import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  FirebaseAuth get auth => FirebaseAuth.instance;



  // Future<void> sendSignInLinkToEmail(String email) async {
  //   final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
  //     url: 'https://www.example.com/finishSignUp?cartId=1234', // Replace with your own URL
  //     handleCodeInApp: true,
       
  //     dynamicLinkDomain: 'example.page.link',
  //   );

  //   try {
  //     await auth.sendSignInLinkToEmail(email: email, actionCodeSettings: actionCodeSettings);
  //     // Save the email locally to complete the sign-in after the user clicks the link.
  //     // You can use shared_preferences or another local storage solution
  //     print('Email link sent to $email');
  //   } catch (e) {
  //     print('Error sending email link: $e');
  //   }
  // }

  // Future<void> signInWithEmailLink(String email, String emailLink) async {
  //   try {
  //     if (auth.isSignInWithEmailLink(emailLink)) {
  //       await auth.signInWithEmailLink(email: email, emailLink: emailLink);
  //       print('Successfully signed in with email link');
  //     } else {
  //       print('Invalid email link');
  //     }
  //   } catch (e) {
  //     print('Error signing in with email link: $e');
  //   }
  // }
}

final FirebaseService firebaseService = FirebaseService.instance;


class RegisterController {
  static final RegisterController _instance = RegisterController._internal();

  factory RegisterController() {
    return _instance;
  }

  RegisterController._internal();

  static RegisterController get instance => _instance;

Future<String?> registerUser(String email, String password) async {
  try {
    // Create a new user with email and password
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Send email verification
    User? user = userCredential.user;
    await user?.sendEmailVerification();

    return 'verified'; // Indicates success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }
}