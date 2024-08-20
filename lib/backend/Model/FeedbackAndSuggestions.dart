import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackAndSuggestions{
  

  final String? id;
  final String? authorID;
  final String content;
  
  FeedbackAndSuggestions({this.id, this.authorID, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'authorID': authorID,
      'content': content,
    };
  }

  factory FeedbackAndSuggestions.fromMap(String id, Map<String, dynamic> data){
    return FeedbackAndSuggestions(
      id: id,
      authorID: (data['authorID'] as DocumentReference).id,
      content: data['content'],
    );
  }

}