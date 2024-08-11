import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:campus_app/screens/home_page.dart';
import 'package:campus_app/screens/search_page.dart';
import 'package:campus_app/screens/activities_page.dart';
import 'package:campus_app/screens/profile_page.dart';
import 'package:campus_app/screens/add_post_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MyHomePage(title: 'Campus App'),
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
    print('Building MainScreen with selected index $_selectedIndex'); // Debug statement
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _onItemSelected,
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Post'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notif'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
