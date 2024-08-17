import 'package:campus_app/backend/Model/Comment.dart';

class LostAndFound {

  // Missing the item image as the type is according to the implementation
  String id;
  String authorID;
  bool isFound;
  String content;
  String category; // could be changed to enum depending on need
  DateTime createdAt;
  List<Comment> comments;

  LostAndFound({required this.id, required this.authorID, required this.isFound, required this.content,
  required this.category, required this.createdAt, required this.comments});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorID': authorID,
      'isFound': isFound,
      'content': content,
      'category': category,
      'createdAt': createdAt,
      'comments': comments
    };
  }

  factory LostAndFound.fromMap(Map<String, dynamic> map){
    return LostAndFound(
      id: map['id'],
      authorID: map['authorID'],
      isFound: map['isFound'],
      content: map['content'],
      category: map['category'],
      createdAt: map['createdAt'],
      comments: map['comments']
    );
  }

}