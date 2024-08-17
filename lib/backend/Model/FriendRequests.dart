class FriendRequests{

  String senderID;
  String receiverID;
  DateTime createdAt;


  FriendRequests({ required this.senderID, required this.receiverID, required this.createdAt });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'createdAt': createdAt,
    };
  }

  factory FriendRequests.fromMap(Map<String, dynamic> map){
    return FriendRequests(
      senderID: map['senderID'],
      receiverID: map['receiverID'],
      createdAt: map['createdAt'],
    );
  }

}