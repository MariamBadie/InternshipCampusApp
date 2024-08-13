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

  void _refreshPosts() {
  setState(() {
    _posts.shuffle();
    _events.shuffle();

    _confessionsAndHelpPosts = _posts.where((post) => post.type == 'Confession' || post.type == 'Help').toList();
    _eventPosts = _posts.where((post) => post.type == 'Event').toList();
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
      post.comments.add(Comment(username: username, content: content, reactions: {'like': 0, 'dislike': 0, 'love': 0}));
    });
  }

  void _reactToComment(String postId, int commentIndex, String reactionType) {
    setState(() {
      final post = _posts.firstWhere((post) => post.id == postId);
      post.comments[commentIndex].reactions[reactionType] = (post.comments[commentIndex].reactions[reactionType] ?? 0) + 1;
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
      body: _buildHomeScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showPostOptions(context, (type) => navigateToPostCreation(context, type, _addNewPost)),
        tooltip: 'Post',
        child: const Icon(Icons.add),
      ),
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
    child: ListView(
      children: [
        // Feed section
        if (_filter == 'All' || _filter == 'Confessions' || _filter == 'Help') 
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Feed', style: Theme.of(context).textTheme.titleLarge),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _confessionsAndHelpPosts.length,
                  itemBuilder: (context, index) {
                    final post = _confessionsAndHelpPosts[index];
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
              ],
            ),
          ),

        // Events section
        if (_filter == 'All' || _filter == 'Events')
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Events', style: Theme.of(context).textTheme.titleLarge),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _eventPosts.length,
                  itemBuilder: (context, index) {
                    final post = _eventPosts[index];
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
              ],
            ),
          ),

        // Rest of the posts
        if (_filter == 'All')
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
      ],
    ),
  );
}

}
