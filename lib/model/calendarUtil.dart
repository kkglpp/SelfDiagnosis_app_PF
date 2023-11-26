import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  
  final String result;
  final DateTime datetime;
  final int category;
  final int rs;
  final DateTime datetime_origin;
  const Event(this.title, this.result, this.datetime, this.category, this.rs, this.datetime_origin);

  @override
  String toString() => title+" "+result;

}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kEventSource);


// 날짜 클릭했을때 나오는 리스트.
Map<DateTime, List<Event>> kEventSource = {


};


// 날짜를 key로 사용.
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
