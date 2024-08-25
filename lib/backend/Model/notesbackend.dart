import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String number;
  final String content;
  final List<String> attachmentPaths;
  final List<Comment> comments;

  Note({
    this.id = '',
    required this.title,
    required this.number,
    required this.content,
    required this.attachmentPaths,
    required this.comments,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      number: data['number'] ?? '',
      content: data['content'] ?? '',
      attachmentPaths: List<String>.from(data['attachmentPaths'] ?? []),
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((commentData) => Comment.fromMap(commentData))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'number': number,
      'content': content,
      'attachmentPaths': attachmentPaths,
      'comments': comments.map((comment) => comment.toMap()).toList(),
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
