import 'comment.dart';



class Post {
  final String id;
  final String username;
  final String type;
  final String content;
  final Map<String, int> reactions;
  final List<Comment> comments;
  final bool isAnonymous;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.username,
    required this.type,
    required this.content,
    required this.reactions,
    required this.comments,
    this.isAnonymous = false,
    required this.timestamp,
  });
}