class Notification{
  String id;
  String receiverID; // User to receive notification if it is private
  bool isPublic;
  DateTime date;
  String content;

  Notification({  required this.id, required this.receiverID, required this.isPublic,
    required this.date, required this.content });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverID': receiverID,
      'isPublic': isPublic,
      'date': date,
      'content': content,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map){
    return Notification(
        id: map['id'],
        receiverID: map['receiverID'],
        isPublic: map['isPublic'],
        date: map['date'],
        content: map['content']
    );
  }
}