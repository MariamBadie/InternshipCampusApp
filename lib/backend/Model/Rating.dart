enum RatingType {
  professor,
  course,
  outlet
}

class Rating {

  String id;
  String authorID;
  RatingType entityType;
  String entityID;
  String content;
  int upCount;
  int downCount;
  bool isAnonymous;
  int rating; // 1-5 or enum

  Rating({required this.id, required this.entityType, required this.authorID, required this.content,
  required this.upCount, required this.downCount, required this.isAnonymous, required this.entityID, required this.rating});

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
      'rating': rating
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map){
    return Rating(
      id: map['id'],
      entityType: map['entityType'],
      authorID: map['authorID'],
      content: map['content'],
      upCount: map['upCount'],
      downCount: map['downCount'],
      isAnonymous: map['isAnonymous'],
      entityID: map['entityID'],
      rating: map['rating']
    );
  }

}