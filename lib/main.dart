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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/search': (context) => SearchPage(),
        '/notifications': (context) => const Activities(),
        '/profile': (context) => ProfilePage(),
        '/editProfile': (context) => EditProfilePage(),
        '/settings': (context) => const SettingsPage2(),
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
