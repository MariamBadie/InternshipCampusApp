class Post {
  final String id;
  final String username;
  final String type;
  String content;
  final Map<String, int> reactions;
  final List<Comment> comments;
  final bool isAnonymous;
  final DateTime timestamp;
  final String profilePictureUrl; // Field for profile picture
  String privacy;
  String? imageUrl; // New field for the image URL

  Post({
    required this.id,
    required this.username,
    required this.type,
    required this.content,
    required this.reactions,
    required this.comments,
    required this.isAnonymous,
    required this.timestamp,
    required this.profilePictureUrl,
    this.privacy = 'Public',
    this.imageUrl, // Initialize the image URL (optional)
  });
}

class Comment {
  final String username;
  final String content;
  final Map<String, int> reactions;
  final String profilePictureUrl;
  List<Reply>? replies; // Field to store replies

  Comment({
    required this.username,
    required this.content,
    required this.reactions,
    required this.profilePictureUrl,
    this.replies,
  });
}

class Reply {
  final String username;
  final String content;
  final String profilePictureUrl;

  Reply({
    required this.username,
    required this.content,
    required this.profilePictureUrl,
  });
}
