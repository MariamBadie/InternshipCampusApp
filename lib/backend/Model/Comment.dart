import 'package:campus_app/backend/Model/User.dart';

class Comment {

  String id;
  List<Comment> replies;
  String authorID;
  List<String> upVoters;
  List<String> downVoters;
  DateTime createdAt;
  String content;


  Comment({required this.id, required this.replies, required this.authorID, required this.upVoters,
  required this.downVoters, required this.createdAt, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'replies': replies,
      'authorID': authorID,
      'upVoters': upVoters,
      'downVoters': downVoters,
      'createdAt': createdAt,
      'content': content
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map){
    return Comment(
      id: map['id'],
      replies: map['replies'],
      authorID: map['authorID'],
      upVoters: map['upVoters'],
      downVoters: map['downVoters'],
      createdAt: map['createdAt'],
      content: map['content']
    );
  }

}