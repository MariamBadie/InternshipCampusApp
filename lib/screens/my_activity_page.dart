import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  final List<Map<String, String>> posts = [
    {
      'title': 'Post 1',
      'content': 'This is the content of post 1.',
      'type': 'normal Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 2',
      'content': 'This is the content of post 2.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 3',
      'content': 'This is the content of post 3.',
      'type': 'normal Post',
      'description': 'Shopping'
    },
    {
      'title': 'Post 4',
      'content': 'This is the content of post 4.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 5',
      'content': 'This is the content of post 5.',
      'type': 'normal Post',
      'description': 'Shopping'
    },
    {
      'title': 'Post 6',
      'content': 'This is the content of post 6.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
  ];

  final List<Map<String, String>> comments = [
    {
      'user': 'User 1',
      'comment': 'This is the first comment. I really enjoyed the content!',
    },
    {
      'user': 'User 2',
      'comment': 'Great post! Thanks for sharing this information.',
    },
    {
      'user': 'User 3',
      'comment': 'I found this very helpful. Looking forward to more posts!',
    },
    {
      'user': 'User 4',
      'comment': 'Interesting perspective. I hadn\'t thought about it this way.',
    },
    {
      'user': 'User 5',
      'comment': 'Can you provide more details on this topic? Thanks!',
    },
  ];

  List<Widget> _buildPosts(List<Map<String, String>> posts, {bool showHeart = false}) {
    return posts.map((post) {
      return Container(
        width: 300, // Fixed width for each post
        margin: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(post['title'] ?? 'No Title'),
                    subtitle: Text(post['content'] ?? 'No Content'),
                    trailing: Text(post['type'] ?? 'No Type'),
                  ),
                ],
              ),
              if (showHeart)
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildComments(List<Map<String, String>> comments) {
    return comments.map((comment) {
      return Container(
        width: 300, // Fixed width for each comment
        margin: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          child: ListTile(
            title: Text(comment['user'] ?? 'Anonymous'),
            subtitle: Text(comment['comment'] ?? 'No Comment'),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Activities",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(height: 20),
              const Text(
                "Liked",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying posts
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (posts.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, posts.length);
                      final pagePosts = posts.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildPosts(pagePosts, showHeart: true),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Commented",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying comments
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (comments.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, comments.length);
                      final pageComments = comments.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildComments(pageComments),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Yesterday",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(height: 20),
              const Text(
                "Liked",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying posts
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (posts.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, posts.length);
                      final pagePosts = posts.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildPosts(pagePosts, showHeart: true),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Commented",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying comments
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (comments.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, comments.length);
                      final pageComments = comments.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildComments(pageComments),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Monday",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              const SizedBox(height: 20),
              const Text(
                "Liked",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying posts
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (posts.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, posts.length);
                      final pagePosts = posts.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildPosts(pagePosts, showHeart: true),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Commented",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 200, // Height for displaying comments
                child: Scrollbar(
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (comments.length / 4).ceil(), // Number of pages
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 4;
                      final endIndex = (startIndex + 4).clamp(0, comments.length);
                      final pageComments = comments.sublist(startIndex, endIndex);
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildComments(pageComments),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
