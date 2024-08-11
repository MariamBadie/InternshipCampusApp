import 'package:flutter/material.dart';
import 'package:campus_app/screens/main_screen.dart';
import 'package:campus_app/screens/search_page.dart';
import 'package:campus_app/screens/add_post_page.dart';
import 'package:campus_app/screens/activities_page.dart';
import 'package:campus_app/screens/profile_page.dart';
import 'package:campus_app/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainScreen(), // Use the new MainScreen here
      routes: {
        '/search': (context) => SearchPage(),
        '/addPost': (context) => AddPostPage(),
        '/notifications': (context) => const Activities(),
        '/profile': (context) => ProfilePage(),
<<<<<<< HEAD
=======
        '/editProfile': (context) => EditProfilePage(),
        '/settings': (context) => const SettingsPage2(),
>>>>>>> b97b689a01e12f2269a08ba77168b24e2186bc4b
      },
    );
  }
}
