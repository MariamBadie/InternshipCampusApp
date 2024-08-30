

import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  String? id; // Add the id field
  Timestamp? timestamp;
  bool? onOff;
  String? content;
  String? userID;

  Reminder({this.id, this.timestamp, this.onOff, this.content, this.userID});

  Map<String, dynamic> toMap() {
    return {
      'time': timestamp,
      'onOff': onOff,
      'content': content,
      'userID': userID
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map, String documentId) {
    return Reminder(
      id: documentId, // Use the document ID
      timestamp: map['time'],
      onOff: map['onOff'],
      content: map['content'],
      userID: map['userID'],
    );
  }
}
