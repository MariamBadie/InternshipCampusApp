class Feedback{

  String id;
  String authorID;
  String content;

  Feedback({ required this.id, required this.authorID, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': authorID,
      'content': content,
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map){
    return Feedback(
      id: map['id'],
      authorID: map['authorID'],
      content: map['content'],
    );
  }

}