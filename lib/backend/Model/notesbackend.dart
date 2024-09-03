import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String userId;
  String? id;
  String title;
  String number;
  String content;

  List<Comment> comments;
  List<Map<String, String>>? attachments;

  Note({
    required this.userId,
    this.id,
    required this.title,
    required this.number,
    required this.content,
    this.comments = const [],
    this.attachments,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Note(
      userId: data['userId'] ?? '',
      id: doc.id,
      title: data['title'] ?? '',
      number: data['number'] ?? '',
      content: data['content'] ?? '',
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c))
          .toList(),
      attachments: (data['attachments'] as List<dynamic>? ?? [])
          .map((a) => Map<String, String>.from(a))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'number': number,
      'content': content,
      'comments': comments.map((c) => c.toMap()).toList(),
      'userId': userId,
      'attachments': attachments,
    };
  }
}

class Comment {
  final String id;
  final String text;
  final String authorName;
  final bool isOwnComment;
  final Timestamp createdAt;

  Comment({
    this.id = '',
    required this.text,
    required this.authorName,
    this.isOwnComment = false,
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      authorName: map['authorName'] ?? '',
      isOwnComment: map['isOwnComment'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'authorName': authorName,
      'isOwnComment': isOwnComment,
      'createdAt': createdAt,
    };
  }
}
