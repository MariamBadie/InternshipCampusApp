import 'package:campus_app/backend/Model/Comment.dart';

class LostAndFound {
  String id;         // Firebase-generated document ID
  String authorID;
  bool isFound;
  String content;
  String category;
  DateTime createdAt;
  List<Comment> comments;
  String? imageUrl;
  String lostOrFound;

  LostAndFound({
    required this.id,
    required this.authorID,
    required this.isFound,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.comments,
    required this.lostOrFound,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID,
      'isFound': isFound,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'imageUrl': imageUrl,
      'lostOrFound': lostOrFound
    };
  }

  factory LostAndFound.fromMap(Map<String, dynamic> map, String id) {
    return LostAndFound(
        id: id,                      // Firebase document ID
        authorID: map['authorID'],
        isFound: map['isFound'],
        content: map['content'],
        category: map['category'],
        createdAt: DateTime.parse(map['createdAt']),
        comments: List<Comment>.from(
            map['comments'].map((comment) => Comment.fromMap(comment))),
        imageUrl: map['imageUrl'],
        lostOrFound: map['lostOrFound']);
  }

}
