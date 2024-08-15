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
    MyHomePage(title: 'Campus Connect'),
    SearchPage(),
    Container(), // Placeholder for AddPostPage, we'll handle this with the bottom navigation bar
    Activities(),
    ProfilePage(),
  ];

  void _onItemSelected(int index) {
    if (index == 2) {
      _showPostOptions(); // Show options when plus icon is tapped
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Post Academic Help'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Help');
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Post Event'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Event');
              },
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: Text('Post Confession'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Confession');
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddPostPage(String postType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(postType: postType),
      ),
    );
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
              'Activities',
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