import 'package:campus_app/backend/Model/User.dart';
import 'package:campus_app/screens/signin.dart';
import 'package:campus_app/utils/UserNotifier.dart';
import 'package:campus_app/utils/getCurrentUser.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:campus_app/screens/home_page.dart';
import 'package:campus_app/screens/search_page.dart';
import 'package:campus_app/screens/activities_page.dart';
import 'package:campus_app/screens/profile_page.dart';
import 'package:campus_app/screens/add_post_page.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});
  // const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MyHomePage(title: 'Campus Connect'),
    const SearchPage(),
    Container(), // Placeholder for AddPostPage, we'll handle this with the bottom navigation bar
    const Activities(),
    const ProfilePage(),
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
              leading: const Icon(Icons.school),
              title: const Text('Post Academic Help'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Help');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Post Event'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Event');
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Post Confession'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Confession');
              },
            ),
            ListTile(
              leading: const Icon(Icons.watch),
              title: const Text('Post Lost & Found'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Lost & Found');
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Post Review/Rating'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Rating/Review');
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Post Notes'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Notes');
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
    final user = getCurrentUser(context);

    // print(user?.toMap());
    
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
