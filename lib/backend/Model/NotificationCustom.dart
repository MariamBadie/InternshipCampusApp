import 'package:campus_app/helpers/custom_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCustom{
  String? id;
  String receiverID; // User to receive notification if it is private
  bool isPublic;
  DateTime createdAt;
  String content;

  NotificationCustom({this.id, required this.receiverID, required this.isPublic,
    required this.createdAt, required this.content });

  Map<String, dynamic> toMap() {
    return {
      'receiverID': receiverID,
      'isPublic': isPublic,
      'createdAt': createdAt,
      'content': content,
    };
  }

  factory NotificationCustom.fromMap(String id, Map<String, dynamic> data){
    return NotificationCustom(
        id: id, // Use the document ID as the id
        receiverID: (data['receiverID'] as DocumentReference).id,
        isPublic: data['isPublic'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        content: data['content']
    );
  }

  String get formattedDate {
    // Register custom messages
    timeago.setLocaleMessages('en', CustomMessages());
    return timeago.format(createdAt, locale: 'en');
  }
}