import 'package:campus_app/screens/lost_and_found_page.dart';
import 'package:campus_app/screens/note_page.dart';
import 'package:campus_app/screens/event_details_page.dart';
import 'package:campus_app/screens/campus_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'package:campus_app/screens/post_details_page.dart';
import '../models/post.dart';
import '../models/event.dart';
import '../widgets/post_card.dart';
import '../widgets/event_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:campus_app/screens/reminder_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Post> _posts = [
    Post(
      id: '1',
      username: 'Hussien Haitham',
      type: 'Confession',
      content: "I really admire Professor Mervat's teaching style!",
      reactions: {'like': 5, 'dislike': 1, 'love': 2},
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
      reactions: {'like': 3, 'dislike': 0, 'love': 1},
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

//   void _editPost(String postId) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       String updatedContent = post.content; // Pre-populate with current content
//       return AlertDialog(
//         title: const Text('Edit Post'),
//         content: TextField(
//           controller: TextEditingController(text: updatedContent),
//           onChanged: (value) {
//             updatedContent = value;
//           },
//           decoration: const InputDecoration(hintText: "Edit your post"),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: const Text('Save'),
//             onPressed: () {
//               if (updatedContent.isNotEmpty) {
//                 // Call your method to save the updated post content
//                 // For example: _savePost(postId, updatedContent);
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
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
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Events'),
          ],
          labelColor: Theme.of(context)
              .colorScheme
              .onPrimary, // Selected tab text color
          unselectedLabelColor: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(0.6), // Unselected tab text color
          indicator: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primary, // Selected tab background color
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for the indicator
          ),
          indicatorSize:
              TabBarIndicatorSize.tab, // Indicator covers the whole tab
          indicatorPadding: const EdgeInsets.symmetric(
              horizontal: 8.0), // Padding around the indicator
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
            _buildDrawerItem(Icons.watch, 'Lost & Found', onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LostAndFoundPage()),
              );
            }),
            _buildDrawerItem(
              Icons.map,
              'Campus Map',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
            ),
            _buildDrawerItem(Icons.forum, 'Confessions'),

            _buildDrawerItem(Icons.rate_review, 'View Reviews & Ratings'),
            _buildDrawerItem(Icons.help, 'Help'),
            _buildDrawerItem(Icons.assignment, "Notes", onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesPage()),
              );
            }),
            _buildDrawerItem(Icons.access_time_rounded, 'Reminders', onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const RemindersPage()),
              );
            }),
            _buildDrawerItem(Icons.event, 'Events'),
            _buildDrawerItem(Icons.logout, 'Log Out', onTap: () {
              // Add functionality to log out
            }),
            const SizedBox(height: 40), // Spacer before the last three items
            const Text("Emergency Contacts"),
            _buildDrawerItem(Icons.medical_services, 'Call Ambulance',
                textStyle: const TextStyle(fontSize: 12), onTap: () {
              _makePhoneCall('911');
            }),
            _buildDrawerItem(Icons.security, 'Call Security',
                textStyle: const TextStyle(fontSize: 12), onTap: () {
              _makePhoneCall('911');
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

  Widget _buildDrawerItem(IconData icon, String title,
      {VoidCallback? onTap, TextStyle? textStyle}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: textStyle),
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }

  Widget _buildFeedSection() {
    final filteredPosts = _posts
        .where((post) => post.type == 'Confession' || post.type == 'Help')
        .toList();

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

void _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
