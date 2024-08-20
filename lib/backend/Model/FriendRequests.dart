import 'package:campus_app/helpers/custom_messages.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequests{
  String? id;
  String senderID;
  String receiverID;
  DateTime createdAt;


  FriendRequests({ this.id, required this.senderID, required this.receiverID, required this.createdAt });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'createdAt': createdAt,
    }; 
  }

  factory FriendRequests.fromMap(String id, Map<String, dynamic> data) {
    return FriendRequests(
      id: id, // Use the document ID as the id
      senderID: (data['senderID'] as DocumentReference).id,
      receiverID: (data['receiverID'] as DocumentReference).id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  String get formattedDate {
    // Register custom messages
    timeago.setLocaleMessages('en', CustomMessages());
    return timeago.format(createdAt, locale: 'en');
  }

}