

import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder{
  Timestamp? timestamp;
  bool?onOff;
  String?content;
  String?userID;
Reminder({this.timestamp, this.onOff, this.content, this.userID});

Map<String,dynamic> toMap(){
return{
  'time':timestamp,
  'onOff':onOff,
  'content':content,
  'userID':userID
};
}

factory Reminder.fromMap(map){
  return Reminder(
    timestamp: map['time'],
    onOff: map['onOff'],
    content: map['content'],
    userID:map['userID']
  );
}

}
