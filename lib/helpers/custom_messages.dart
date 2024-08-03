import 'package:timeago/timeago.dart' as timeago;

class CustomMessages extends timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'just now';
  @override
  String aboutAMinute(int minutes) => '1 min';
  @override
  String minutes(int minutes) => '$minutes mins';
  @override
  String aboutAnHour(int minutes) => '1 hr';
  @override
  String hours(int hours) => '$hours hrs';
  @override
  String aDay(int hours) => '1 day';
  @override
  String days(int days) => '$days days';
  @override
  String aboutAMonth(int days) => '1 month';
  @override
  String months(int months) => '$months months';
  @override
  String aboutAYear(int year) => '1 year';
  @override
  String years(int years) => '$years years';
}
