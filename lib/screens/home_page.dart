import 'package:campus_app/screens/NotesPage.dart';
import 'package:campus_app/screens/content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing

import '../models/post.dart';
import '../models/event.dart';
import '../widgets/post_card.dart';
import '../widgets/event_card.dart';
import '../utils/home_page_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  final List<Post> _confessionsAndHelpPosts = [];
  final List<Event> _events = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Post> _confessionsAndHelpPosts = [];
  final List<Event> _eventPosts = [];

  String _filter = 'All';

  final List<Post> _posts = [
    Post(
      id: '1',
      username: 'Ahmed',
      type: 'Confession',
      content: "I really admire Professor Ali's teaching style!",
      reactions: {'like': 5, 'dislike': 1, 'love': 2, 'haha': 0},
      comments: [
        Comment(
            username: 'Sara',
            content: 'I agree! His lectures are great.',
            reactions: {'like': 2, 'dislike': 0, 'love': 1}),
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

  final List<Event> _events = [
    Event(
      id: '1',
      title: "Mother's Day Bazaar",
      description:
          "Join us for a special Mother's Day Bazaar at the basketball court!",
      date: DateTime(2024, 5, 12, 10, 0),
      location: "Basketball Court",
    ),
    Event(
      id: '2',
      title: "Computer Science Club Meetup",
      description: "Learn about the latest trends in AI and Machine Learning",
      date: DateTime(2024, 5, 15, 14, 0),
      location: "Room 301, Computer Science Building",
    ),
  ];

  void _refreshPosts() {
    setState(() {
      _posts.shuffle();
      _events.shuffle();
    });
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
      post.comments.add(Comment(
          username: username,
          content: content,
          reactions: {'like': 0, 'dislike': 0, 'love': 0}));
    });
  }

  void _reactToComment(String postId, int commentIndex, String reactionType) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.comments[commentIndex].reactions[reactionType] =
          (post.comments[commentIndex].reactions[reactionType] ?? 0) + 1;
    });
  }

  void _sharePost(String postId) {
    final post = _posts.firstWhere((post) => post.id == postId);
    final postUrl = 'https://example.com/posts/$postId'; // Example URL format
    Share.share('Check out this post: $postUrl');
  }

  void _copyPostLink(String postId) {
    final post = _posts.firstWhere((post) => post.id == postId);
    final postUrl = 'https://example.com/posts/$postId'; // Example URL format
    Clipboard.setData(ClipboardData(text: postUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link copied to clipboard!')),
    );
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
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(Icons.all_inclusive, 'All'),
            _buildDrawerItem(Icons.forum, 'Confessions'),
            _buildDrawerItem(Icons.help, 'Help'),
            _buildStudyingContent(),
            _buildDrawerItem(Icons.event, 'Events'),
            _buildDrawerItem(Icons.logout, 'Log Out', onTap: () {
              // Add functionality to log out
            }),
          ],
        ),
      ),
      body: _buildHomeScreen(),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap ??
          () {
            setState(() => _filter = title);
            Navigator.pop(context);
          },
    );
  }

  Widget _buildStudyingContent() {
    return ExpansionTile(
      leading: Icon(Icons.assignment),
      title: Text("Studying content"),
      children: [
        ListTile(
          title: Text('Content Page'),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => ContentPage())),
        ),
        ListTile(
          title: Text('Notes Page'),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotesPage())),
        ),
      ],
    );
  }

  Widget _buildHomeScreen() {
    final filteredPosts = _filter == 'All'
        ? _posts
        : _posts.where((post) => post.type == _filter).toList();

    return RefreshIndicator(
      onRefresh: () async {
        _refreshPosts();
      },
      child: ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return GestureDetector(
            onTap: () => navigateToPostDetails(
              context,
              post,
              _reactToPost,
              _addCommentToPost,
              _reactToComment,
            ),
            child: PostCard(
              post: post,
              onReact: _reactToPost,
              onComment: _addCommentToPost,
              onShare: () => _sharePost(post.id),
              onCopyLink: () => _copyPostLink(post.id),
              onTap: () => navigateToPostDetails(
                context,
                post,
                _reactToPost,
                _addCommentToPost,
                _reactToComment,
              ),
            ),
          );
        },
      ),
    );
  }
}
