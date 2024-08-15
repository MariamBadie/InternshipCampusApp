import 'package:campus_app/screens/NotesPage.dart';
import 'package:campus_app/screens/content_page.dart';
import 'package:campus_app/screens/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:campus_app/screens/post_details_page.dart';
import '../screens/settings.dart';
import '../models/post.dart';
import '../models/event.dart';
import '../widgets/post_card.dart';
import '../widgets/event_card.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final List<Post> _posts = [
    Post(
      id: '1',
      username: 'Hussien Haitham',
      type: 'Confession',
      content: "I really admire Professor Mervat's teaching style!",
      reactions: {'like': 5, 'dislike': 1, 'love': 2, 'haha': 0},
      comments: [
        Comment(
          username: 'Anas',
          content: 'I agree! Her lectures are great.',
          reactions: {'like': 2, 'dislike': 0, 'love': 1},
          profilePictureUrl: 'assets/images/anas.jpg',
        ),
        Comment(
          username: 'Mohanad',
          content: 'What subjects does she teach?',
          reactions: {'like': 2, 'dislike': 0, 'love': 1},
          profilePictureUrl: 'assets/images/mohanad.jpg',
        )
      ],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      profilePictureUrl: 'assets/images/hussien.jpg',
    ),
    Post(
      id: '2',
      username: 'Ahmed Hany',
      type: 'Help',
      content: 'Can someone help me with Math203 problems?',
      reactions: {'like': 3, 'dislike': 0, 'love': 1, 'haha': 0},
      comments: [
        Comment(
          username: 'Ibrahim',
          content: 'Sure, tell me how can I help?',
          reactions: {'like': 2, 'dislike': 0, 'love': 1},
          profilePictureUrl: 'assets/images/ibrahim.jpg',
        )
      ],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      profilePictureUrl: 'assets/images/ahmed.jpg',
    ),
  ];

  final List<Event> _events = [
    Event(
      id: '1',
      title: "Mother's Day Bazaar",
      description: "Join us for a special Mother's Day Bazaar at the basketball court!",
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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        reactions: {'like': 0, 'dislike': 0, 'love': 0},
        profilePictureUrl: '',
      ));
    });
  }

  void _reactToComment(String postId, int commentIndex, String reactionType) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.comments[commentIndex].reactions[reactionType] =
          (post.comments[commentIndex].reactions[reactionType] ?? 0) + 1;
    });
  }

  void _replyToComment(String postId, int commentIndex, String replyContent) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      final comment = post.comments[commentIndex];
      comment.replies?.add(Reply(
        username: 'Current User', // Replace with the actual username
        content: replyContent,
        profilePictureUrl: 'assets/images/default_user.jpg', // Replace with the actual profile picture URL
      ));
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
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Events'),
          ],
          labelColor: Theme.of(context).colorScheme.onPrimary, // Selected tab text color
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), // Unselected tab text color
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary, // Selected tab background color
            borderRadius: BorderRadius.circular(8), // Rounded corners for the indicator
          ),
          indicatorSize: TabBarIndicatorSize.tab, // Indicator covers the whole tab
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding around the indicator
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(Icons.home, 'Home'),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedSection(),
          _buildEventsSection(),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildStudyingContent() {
    return ExpansionTile(
      leading: const Icon(Icons.assignment),
      title: const Text("Studying content"),
      children: [
        ListTile(
          title: const Text('Content Page'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContentPage()),
          ),
        ),
        ListTile(
          title: const Text('Notes Page'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotesPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedSection() {
    final filteredPosts = _posts.where((post) => post.type == 'Confession' || post.type == 'Help').toList();

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
              onReactToComment: _reactToComment,
              onReplyToComment: _replyToComment,
              onShare: () => _sharePost(post.id),
              onCopyLink: () => _copyPostLink(post.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsSection() {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshPosts();
      },
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void navigateToPostDetails(BuildContext context, Post post, Function(String, String) onReact, Function(String, String, String) onComment, Function(String, int, String) onReactToComment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsPage(
          post: post,
          onReact: onReact,
          onComment: onComment,
          onReactToComment: onReactToComment,
        ),
      ),
    );
  }
}