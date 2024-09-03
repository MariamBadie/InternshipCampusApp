import 'package:campus_app/screens/lost_and_found_page.dart';
import 'package:campus_app/screens/ranking_page.dart';
import 'package:campus_app/screens/reminder_page.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/models/ThemeNotifier.dart'; // Import the ThemeNotifier
import 'package:campus_app/screens/main_screen.dart';
import 'package:campus_app/screens/settings.dart';
import 'package:campus_app/screens/search_page.dart';
import 'package:campus_app/screens/activities_page.dart';
import 'package:campus_app/screens/profile_page.dart';
import 'package:campus_app/screens/edit_profile_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform; // Import for Platform
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
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
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  await dotenv.load(fileName: ".env");

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Campus Connect',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light), // Light theme
      darkTheme: _buildTheme(Brightness.dark), // Dark theme
      themeMode:
          themeProvider.themeMode, // Use the theme mode from the provider
      home: MainScreen(),
      routes: {
        '/search': (context) =>  SearchPage(),
        '/notifications': (context) =>  Activities(),
        '/profile': (context) =>  ProfilePage(),
        '/editProfile': (context) =>const EditProfilePage(
    currentName: 'Anas Tamer', // Replace with actual user data
    currentBio: 'MET Major | Student at GUC', // Replace with actual user data
    currentImageUrl: 'assets/images/anas.jpg', // Replace with actual user image URL
  ),
        '/settings': (context) => const SettingsPage2(),
        '/lostandfoundpage': (context) => LostAndFoundPage(),
        '/reminder_page': (context) =>const  RemindersPage(),
        '/ranking_page': (context) =>const RankingPage(),
        '/homepage': (context) => MainScreen()
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    bool isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: isDark ? Colors.teal[800]! : Colors.teal,
        brightness: brightness,
      ),
      useMaterial3: true,
      textTheme: TextTheme(
        bodyLarge:
            TextStyle(color: isDark ? Colors.white70 : Colors.brown[900]),
        bodyMedium:
            TextStyle(color: isDark ? Colors.white70 : Colors.brown[900]),
        headlineSmall:
            TextStyle(color: isDark ? Colors.white : Colors.brown[900]),
        headlineMedium:
            TextStyle(color: isDark ? Colors.white : Colors.brown[800]),
        titleMedium:
            TextStyle(color: isDark ? Colors.white70 : Colors.brown[800]),
        bodySmall:
            TextStyle(color: isDark ? Colors.white54 : Colors.brown[600]),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.teal[900] : Colors.teal[800],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? Colors.amber[700] : const Color(0xFFc98e53),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: isDark ? Colors.teal[700] : Colors.teal[700],
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.teal[50],
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: isDark ? Colors.teal[500]! : Colors.teal[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: isDark ? Colors.teal[700]! : Colors.teal[600]!),
        ),
      ),
      cardTheme: CardTheme(
        color: isDark ? Colors.grey[850] : const Color(0xFFF8E8D3),
        elevation: 5,
        shadowColor: isDark ? Colors.black : Colors.teal[200],
      ),
      iconTheme:
          IconThemeData(color: isDark ? Colors.teal[400] : Colors.teal[700]),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.teal[200] : Colors.teal[200],
        indicator: BoxDecoration(
          color: isDark ? Colors.teal[700] : Colors.teal[700],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? Colors.grey[850] : const Color(0xFFF8E8D3),
      ),
    );
  }
}
