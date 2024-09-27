import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_app/screens/post_details_page.dart';
import '../widgets/post_card.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Model/Comment.dart';
import 'package:campus_app/backend/Model/LostAndFound.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:campus_app/screens/post_details_page.dart';
import '../widgets/post_card.dart';
import 'package:intl/intl.dart';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Model/Comment.dart';
import 'package:campus_app/backend/Model/LostAndFound.dart';

class PostCardLostAndFound extends StatelessWidget {
  final LostAndFound post;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final String userName;

  const PostCardLostAndFound(
      {Key? key,
      required this.post,
      required this.onShare,
      required this.onCopyLink,
      required this.onDelete,
      required this.onReport,
      required this.userName})
      : super(key: key);

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
            if (post.imageUrl != null) _buildPostImage(post.imageUrl!),
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
          userName, // TODO: replace with author name
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        Text(
          post.lostOrFound,
          style: const TextStyle(color: Colors.grey),
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

  Widget _buildPostImage(String path) {
    return Container(
      margin: const EdgeInsets.all(4),
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: path.startsWith('http://') || path.startsWith('https://')
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
      ),
    );
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

final String _userID = 'yq2Z9NaQdPz0djpnLynN';

class LostAndFoundPage extends StatefulWidget {
  LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _filteredPosts = [];
  String _searchQuery = '';
  String? _selectedCategory;
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Books',
    'Clothing',
    'Accessories',
    'Keys'
  ];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchPosts() async {
    final posts = await getAllLostAndFoundPosts(_userID);

    List<Map<String, dynamic>> postsWithNames = [];

    for (var post in posts) {
      // Fetch the name of the user who created this post
      String userName = await getUserById(post.authorID);

      // Create the object with 'name' and 'post'
      postsWithNames.add({'name': userName, 'post': post});
    }

    setState(() {
      _posts = postsWithNames;
      _filteredPosts = postsWithNames;
    });
  }

  // void _filterPosts() {
  //   setState(() {
  //     _filteredPosts = _posts.where((post) {
  //       final matchesSearch =
  //           post.content.toLowerCase().contains(_searchQuery.toLowerCase());
  //       final matchesCategory = _selectedCategory == null ||
  //           _selectedCategory == 'All' ||
  //           post.category.toLowerCase() == _selectedCategory?.toLowerCase();
  //       return matchesSearch && matchesCategory;
  //     }).toList();
  //   });
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshPosts() async {
    await _fetchPosts();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    // _filterPosts();
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    // _filterPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text('Filter by category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: _onCategoryChanged,
                ),
              ],
            ),
          ),
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

  Widget _buildFeedSection() {
    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return GestureDetector(
            child: PostCardLostAndFound(
              post: post['post'],
              userName: post['name'],
              onShare: () => _sharePost(post['post']),
              onCopyLink: () => _copyPostLink(post['post']),
              onDelete: () => _deletePost(post['post']),
              onReport: () => _reportPost(post['post']),
            ),
          );
        },
      ),
    );
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Report'),
              onPressed: () {
                if (reportReason.isNotEmpty) {
                  // Implement your report logic here
                  Navigator.of(context).pop();
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Implement your delete logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
