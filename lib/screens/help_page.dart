import 'package:flutter/material.dart';
import '../backend/Model/Post.dart';
import '../widgets/post_card.dart';

class HelpPage extends StatelessWidget {
  final List<Post> posts;

  const HelpPage({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final helpPosts = posts.where((post) => post.type == 'Help').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: ListView.builder(
        itemCount: helpPosts.length,
        itemBuilder: (context, index) {
          final post = helpPosts[index];
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
