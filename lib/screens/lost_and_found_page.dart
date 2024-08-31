import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Model/Comment.dart';
import 'package:campus_app/backend/Model/LostAndFound.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_app/screens/post_details_page.dart';
import '../widgets/post_card.dart';
import 'package:intl/intl.dart';

class PostCardLostAndFound extends StatelessWidget {
  final LostAndFound post;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const PostCardLostAndFound({
    Key? key,
    required this.post,
    required this.onShare,
    required this.onCopyLink,
    required this.onDelete,
    required this.onReport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostHeader(),
            const SizedBox(height: 10.0),
            _buildPostContent(),
            const SizedBox(height: 10.0),
            _buildPostImage(),
            const Divider(),
            _buildPostActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(post.createdAt);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          post.authorID, // TODO: replace with author name
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Text(
          formattedDate,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPostContent() {
    return Text(
      post.content,
      style: const TextStyle(fontSize: 14.0),
    );
  }

  Widget _buildPostImage() {
    // For network images
    if (post.imageUrl != null && post.imageUrl!.startsWith('http')) {
      return Image.network(post.imageUrl!);
    }

// For asset images
    if (post.imageUrl != null && !post.imageUrl!.startsWith('http')) {
      return Image.asset(post.imageUrl!);
    }

// Handling cases where image URL is null
    return const SizedBox.shrink();

    // print(post.imageUrl);
    // return post.imageUrl != null
    //     ? Image.network(
    //         post.imageUrl!,
    //         fit: BoxFit.cover,
    //       )
    //     : Container();
  }

  Widget _buildPostActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: onShare,
          tooltip: 'Share Post',
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: onCopyLink,
          tooltip: 'Copy Link',
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
          tooltip: 'Delete Post',
        ),
        IconButton(
          icon: const Icon(Icons.report),
          onPressed: onReport,
          tooltip: 'Report Post',
        ),
      ],
    );
  }
}

const String _userID = 'yq2Z9NaQdPz0djpnLynN';

class LostAndFoundPage extends StatefulWidget {
  LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundPage>
    with SingleTickerProviderStateMixin {
  List<LostAndFound> _posts = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchPosts() async {
    final posts = await getAllLostAndFoundPosts(_userID);
    setState(() {
      _posts = posts;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshPosts() async {
    await _fetchPosts();
  }

  void _addNewPost(LostAndFound newPost) {
    setState(() {
      _posts.insert(0, newPost);
    });
  }

  void _addCommentToPost(String postId, String content) {
    setState(() {
      final post = _posts.firstWhere((post) => post.authorID == postId);
      // post.comments.add(Comment(
      //   username: 'Current User',
      //   content: content,
      //   reactions: {'like': 0, 'dislike': 0, 'love': 0},
      //   profilePictureUrl: 'assets/images/default_user.jpg',
      // ));
    });
  }

  void _sharePost(LostAndFound post) {
    final postUrl = 'https://example.com/posts/${post.authorID}';
    Share.share('Check out this post: $postUrl');
  }

  void _copyPostLink(LostAndFound post) {
    final postUrl = 'https://example.com/posts/${post.authorID}';
    Clipboard.setData(ClipboardData(text: postUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
  }

  void _reportPost(LostAndFound post) {
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
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePost(LostAndFound post) {
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
                setState(() {
                  _posts.remove(post);
                });
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
        title: const Text('Lost & Found'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedSection(),
        ],
      ),
    );
  }

  Widget _buildFeedSection() {
    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          // print(post);
          return GestureDetector(
            // onTap: () => navigateToPostDetails(context, post),
            child: PostCardLostAndFound(
              post: post,
              onShare: () => _sharePost(post),
              onCopyLink: () => _copyPostLink(post),
              onDelete: () => _deletePost(post),
              onReport: () => _reportPost(post),
            ),
          );
        },
      ),
    );
  }

  // void navigateToPostDetails(BuildContext context, LostAndFound post) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PostDetailsPage(
  //         post: post,
  //         onComment: _addCommentToPost,
  //       ),
  //     ),
  //   );
  // }
}
