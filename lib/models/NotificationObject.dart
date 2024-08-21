import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:campus_app/helpers/custom_messages.dart';

class NotificationObject {
  NotificationObject({
    //required this.notficationID,
    required this.notficationText,
    required this.notficationDate,
    required this.notficationImg,
  });

  final String notficationText;
  //String notficationID;
  final DateTime notficationDate;
  final Image notficationImg;

  String get notficationObjectFormattedDate {
    // Register custom messages
    timeago.setLocaleMessages('en', CustomMessages());
    return timeago.format(notficationDate, locale: 'en');
  }
}
