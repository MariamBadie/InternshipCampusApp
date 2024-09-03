class Post {
  final String id;
  final String username;
  final String type;
  String content;
  final String profilePictureUrl;
  final bool isAnonymous;
  final DateTime timestamp;
  int upvotes;
  int downvotes;
  final List<Comment> comments;
  final bool isConfession;
  String privacy; // Added privacy field

  Post({
    required this.id,
    required this.username,
    required this.type,
    required this.content,
    required this.profilePictureUrl,
    this.isAnonymous = false,
    required this.timestamp,
    this.upvotes = 0,
    this.downvotes = 0,
    this.comments = const [],
    this.isConfession = false,
    this.privacy = 'Public', // Initialize with a default value
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'username': username,
      'type': type,
      'content': content,
      'profilePictureUrl': profilePictureUrl,
      'isAnonymous': isAnonymous,
      'timestamp': timestamp.toIso8601String(),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'isConfession': isConfession,
    };
  }

  factory Post.fromFirestore(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      username: map['username'],
      type: map['type'],
      content: map['content'],
      profilePictureUrl: map['profilePictureUrl'],
      isAnonymous: map['isAnonymous'] ?? false,
      timestamp: DateTime.parse(map['timestamp']),
      upvotes: map['upvotes'] ?? 0,
      downvotes: map['downvotes'] ?? 0,
      comments: (map['comments'] as List)
          .map((item) => Comment.fromMap(item))
          .toList(),
      isConfession: map['isConfession'] ?? false,
    );
  }
}

class Comment {
  final String username;
  final String content;
  final String profilePictureUrl;
  int upvotes;
  int downvotes;
  List<Reply> replies;

  Comment({
    required this.username,
    required this.content,
    required this.profilePictureUrl,
    this.upvotes = 0,
    this.downvotes = 0,
    this.replies = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'content': content,
      'profilePictureUrl': profilePictureUrl,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      username: map['username'],
      content: map['content'],
      profilePictureUrl: map['profilePictureUrl'],
      upvotes: map['upvotes'] ?? 0,
      downvotes: map['downvotes'] ?? 0,
      replies: (map['replies'] as List)
          .map((item) => Reply.fromMap(item))
          .toList(),
    );
  }
}

class Reply {
  final String username;
  final String content;
  final String profilePictureUrl;
  int upvotes;
  int downvotes;

  Reply({
    required this.username,
    required this.content,
    required this.profilePictureUrl,
    this.upvotes = 0,
    this.downvotes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'content': content,
      'profilePictureUrl': profilePictureUrl,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      username: map['username'],
      content: map['content'],
      profilePictureUrl: map['profilePictureUrl'],
      upvotes: map['upvotes'] ?? 0,
      downvotes: map['downvotes'] ?? 0,
    );
  }
}
