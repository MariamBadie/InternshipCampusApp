import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:campus_app/screens/home_page.dart';
import 'package:campus_app/screens/search_page.dart';
import 'package:campus_app/screens/activities_page.dart';
import 'package:campus_app/screens/profile_page.dart';
import 'package:campus_app/screens/add_post_page.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MyHomePage(title: 'Campus App'),
    SearchPage(),
    Container(), // Placeholder for AddPostPage, we'll handle this with the bottom navigation bar
    Activities(),
    ProfilePage(),
  ];

  void _onItemSelected(int index) {
    print('Selected Index: $index'); // Debug statement
    if (index == 2) {
      _navigateToAddPostPage();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToAddPostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(),
      ),
    ).then((_) {
      // Debug statement for returning from AddPostPage
      print('Returned from AddPostPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _onItemSelected,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 12),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.search),
            title: const Text(
              'Search',
              style: TextStyle(fontSize: 12),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.add),
            title: const Text(
              'Add Post',
              style: TextStyle(fontSize: 12),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.notifications),
            title: const Text(
              'Notification',
              style: TextStyle(fontSize: 12),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person),
            title: const Text(
              'Profile',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
