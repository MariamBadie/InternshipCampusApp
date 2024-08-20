import 'package:cloud_firestore/cloud_firestore.dart';

enum RatingType {
  professor,
  course,
  outlet
}

class Rating {

  String? id;
  String authorID;
  String entityType;
  String entityID;
  String content;
  int upCount;
  int downCount;
  bool isAnonymous;
  int rating; // 1-5 or enum
  DateTime createdAt;

  Rating({this.id, required this.entityType, required this.authorID,
    required this.content, required this.upCount, required this.downCount,
    required this.isAnonymous, required this.entityID, required this.rating,
    required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entityType': entityType,
      'authorID': authorID,
      'content': content,
      'upCount': upCount,
      'downCount': downCount,
      'isAnonymous': isAnonymous,
      'entityID': entityID,
      'rating': rating,
      'createdAt': createdAt
    };
  }

  factory Rating.fromMap(String id, Map<String, dynamic> map){
    return Rating(
      id: id,
      entityType: map['entityType'],
      authorID: (map['authorID'] as DocumentReference).id,
      content: map['content'],
      upCount: map['upCount'],
      downCount: map['downCount'],
      isAnonymous: map['isAnonymous'],
      entityID: map['entityID'],
      rating: map['rating'],
      createdAt: map['createdAt']
    );
  }

}