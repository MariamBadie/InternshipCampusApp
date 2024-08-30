import 'package:campus_app/screens/main_screen.dart';
// import 'package:campus_app/screens/content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:campus_app/screens/post_details_page.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class LostAndFound extends StatefulWidget {
  const LostAndFound({super.key});

  @override
  State<LostAndFound> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFound>
    with SingleTickerProviderStateMixin {
  final List<Post> _posts = [
    Post(
      id: '1',
      username: 'Hussien Haitham',
      type: 'Lost & Found',
      content: "Found Key",
      reactions: {'like': 5, 'dislike': 1, 'love': 2},
      comments: [
        Comment(
          username: 'Anas',
          content: 'I know its owner @omar.',
          reactions: {'like': 2, 'dislike': 0, 'love': 1},
          profilePictureUrl: 'assets/images/anas.jpg',
        ),
      ],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      profilePictureUrl: 'assets/images/hussien.jpg',
    ),
    Post(
      id: '2',
      username: 'Ahmed Hany',
      type: 'Lost & Found',
      content: 'Can someone help me I lost my ID',
      reactions: {'like': 3, 'dislike': 0, 'love': 1},
      comments: [
        Comment(
          username: 'Anas',
          content: 'I know its owner @omar.',
          reactions: {'like': 2, 'dislike': 0, 'love': 1},
          profilePictureUrl: 'assets/images/anas.jpg',
        ),
      ],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      profilePictureUrl: 'assets/images/ahmed.jpg',
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
        profilePictureUrl:
            'assets/images/default_user.jpg', // Replace with the actual profile picture URL
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

  void _reportPost(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String reportReason = '';
        return AlertDialog(
          title: const Text('Report Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please select a reason for reporting this post:'),
              TextField(
                onChanged: (value) {
                  reportReason = value;
                },
                decoration: const InputDecoration(hintText: "Enter reason"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Report'),
              onPressed: () {
                if (reportReason.isNotEmpty) {
                  // Implement your report logic here
                  // For example: _performReport(postId, reportReason);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePost(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Implement your deletion logic here
                // For example: _performDelete(postId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lost & Found'),
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
            _buildDrawerItem(Icons.home, 'Home', onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainScreen()));
            }),
            _buildDrawerItem(Icons.watch, 'Lost & Found'),
            _buildDrawerItem(Icons.forum, 'Confessions'),
            _buildDrawerItem(Icons.rate_review, 'View Reviews & Ratings'),
            _buildDrawerItem(Icons.help, 'Help'),
            // _buildStudyingContent(),
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
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }

  Widget _buildFeedSection() {
    final filteredPosts = _posts;

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
              // onEdit:() => _editPost(post.id),
              // onDelete: () => _deletePost(post.id),
              onReport: () => _reportPost(post.id),
            ),
          );
        },
      ),
    );
  }

  void navigateToPostDetails(
      BuildContext context,
      Post post,
      Function(String, String) onReact,
      Function(String, String, String) onComment,
      Function(String, int, String) onReactToComment) {
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
