import 'package:flutter/material.dart';
import '../backend/Model/Post.dart';
import '../widgets/post_card.dart';

class ConfessionsPage extends StatelessWidget {
  final List<Post> posts;

  const ConfessionsPage({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confessionPosts = posts.where((post) => post.type == 'Confession').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confessions'),
      ),
      body: ListView.builder(
        itemCount: confessionPosts.length,
        itemBuilder: (context, index) {
          final post = confessionPosts[index];
          return PostCard(
            post: post,
            onReact: (postId, reactionType) {
              // Implement reaction logic here
            },
            onComment: (postId, username, content) {
              // Implement comment logic here
            },
            onReactToComment: (postId, commentIndex, reactionType) {
              // Implement comment reaction logic here
            },
            onReplyToComment: (postId, commentIndex, replyContent) {
              // Implement reply logic here
            },
            onShare: () {},
            onCopyLink: () {}, onDelete: () {  }, onReport: () {  },
          );
        },
      ),
    );
  }
}
