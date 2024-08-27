import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String title;
  String number;
  String content;
  String? attachmentUrl;
  List<Comment> comments;

  Note({
    this.id,
    required this.title,
    required this.number,
    required this.content,
    this.attachmentUrl,
    this.comments = const [],
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      number: data['number'] ?? '',
      content: data['content'] ?? '',
      attachmentUrl: data['attachmentUrl'],
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'number': number,
      'content': content,
      'attachmentUrl': attachmentUrl,
      'comments': comments.map((c) => c.toMap()).toList(),
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
