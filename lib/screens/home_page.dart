import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart'; // Import the package
import 'package:campus_app/screens/settings.dart';
import '../models/post.dart';
import '../models/event.dart';
import '../widgets/post_card.dart';
import '../widgets/event_card.dart';
import 'post_creation_page.dart';
import 'post_details_page.dart';
import 'event_details_page.dart';
import '../models/comment.dart';
export 'home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _filter = 'All';

  final List<Post> _posts = [
    Post(
      id: '1',
      username: 'Ahmed',
      type: 'Confession',
      content: "I really admire Professor Ali's teaching style!",
      reactions: {'like': 5, 'dislike': 1, 'love': 2, 'haha': 0},
      comments: [
        Comment(username: 'Sara', content: 'I agree! His lectures are great.', reactions: {'like': 2, 'dislike': 0, 'love': 1}),
      ],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Post(
      id: '2',
      username: 'Sara',
      type: 'Help',
      content: 'Can someone help me with Math203 problems?',
      reactions: {'like': 3, 'dislike': 0, 'love': 1, 'haha': 0},
      comments: [],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  // Dummy data for events
  final List<Event> _events = [
    Event(
      id: '1',
      title: "Mother's Day Bazaar",
      description: "Join us for a special Mother's Day Bazaar at the basketball court!",
      date: DateTime(2024, 5, 12, 10, 0), // May 12, 2024, 10:00 AM
      location: "Basketball Court",
    ),
    Event(
      id: '2',
      title: "Computer Science Club Meetup",
      description: "Learn about the latest trends in AI and Machine Learning",
      date: DateTime(2024, 5, 15, 14, 0), // May 15, 2024, 2:00 PM
      location: "Room 301, Computer Science Building",
    ),
  ];


  void _onItemSelected(int index) {
    setState(() {
      if (index == 2) { // Check if the "Add Post" tab is selected
        _navigateToPostCreation(context, 'Confession'); // Navigate to PostCreationPage
      } else {
        _selectedIndex = index;
      }
    });
  }

  void _refreshPosts() {
    setState(() {
      _posts.shuffle();
      _events.shuffle();
    });
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Post Confession'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPostCreation(context, 'Confession');
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Post Academic Question'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPostCreation(context, 'Help');
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Post an Event/Activity'),
              onTap: () {
                Navigator.pop(context);
                _navigateToPostCreation(context, 'Event');
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToPostCreation(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostCreationPage(type: type, onPostCreated: _addNewPost),
      ),
    );
  }

  void _addNewPost(Post newPost) {
    setState(() {
      _posts.insert(0, newPost);
    });
  }

  void _reactToPost(String postId, String reactionType) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.reactions[reactionType] = (post.reactions[reactionType] ?? 0) + 1;
    });
  }

  void _addCommentToPost(String postId, String username, String content) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.comments.add(Comment(username: username, content: content, reactions: {'like': 0, 'dislike': 0, 'love': 0}));
    });
  }

  void _reactToComment(String postId, int commentIndex, String reactionType) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.comments[commentIndex].reactions[reactionType] = (post.comments[commentIndex].reactions[reactionType] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
     

drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.all_inclusive),
              title: Text('All'),
              onTap: () {
                setState(() {
                  _filter = 'All';
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: Text('Confessions'),
              onTap: () {
                setState(() {
                  _filter = 'Confessions';
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                setState(() {
                  _filter = 'Help';
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Events'),
              onTap: () {
                setState(() {
                  _filter = 'Events';
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Add functionality to log out
              },
            ),
          ],
        ),
      ),
      body: _getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostOptions(context),
        tooltip: 'Post',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.add),
            title: Text(''),
          ),
          
         FlashyTabBarItem(
            icon: Icon(Icons.notifications), // Notification icon
            title: Text('Notification'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),

          
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildMapTab();
      case 4:
        return _buildSettingsTab();
      case 3:
        return Center(child: Text('Notifications functionality coming soon.'));
      default:
        return Container();
    }
  }

  Widget _buildHomeTab() {
    List<Widget> items = [];

    if (_filter == 'All' || _filter == 'Confessions' || _filter == 'Help') {
      items.addAll(_posts
          .where((post) => _filter == 'All' || post.type == _filter)
          .map((post) => PostCard(
                post: post,
                onReact: _reactToPost,
                onComment: _addCommentToPost,
                onTap: () => _navigateToPostDetails(post),
              )));
    }

    if (_filter == 'All' || _filter == 'Events') {
      items.addAll(_events.map((event) => EventCard(
            event: event,
            onTap: () => _navigateToEventDetails(event),
          )));
    }

    return RefreshIndicator(
      onRefresh: () async {
        _refreshPosts();
      },
      child: ListView(
        children: items,
      ),
    );
  }

  Widget _buildMapTab() {
    return Center(
      child: Text('Map functionality coming soon.'),
    );
  }

  Widget _buildSettingsTab() {
    return SettingsPage2();
  }

  void _navigateToPostDetails(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsPage(
          post: post,
          onReact: _reactToPost,
          onComment: _addCommentToPost,
          onReactToComment: _reactToComment,
        ),
      ),
    );
  }

  void _navigateToEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(event: event),
      ),
    );
  }
}
