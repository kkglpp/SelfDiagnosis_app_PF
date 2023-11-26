import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/kkg_RSdetail.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/calendarUtil.dart';
import 'package:http/http.dart' as http;

class tableCalendar_summary extends StatefulWidget {
  @override
  _tableCalendar_summaryState create() => _tableCalendar_summaryState();

  //const tableCalendar_summary({super.key});

  @override
  State<tableCalendar_summary> createState() => _tableCalendar_summaryState();
}

class _tableCalendar_summaryState extends State<tableCalendar_summary> {
  // 목록채우기 위한 임시 변수

  late List wholeList_List;

  // 기본 셋팅
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late List rsList;
  late String uid;

  //기초셋팅
  late ValueNotifier<List<Event>> _selectedEvents;

  // 추가 작업 범위 선택기능 구현할떄를 위한 변수. (현재 미구현)
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    uid = "";

    //kEventSource = {};
    rsList = [];
    _getList();
    _selectedDay = _focusedDay;

    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  //끌때 작동해야 되는  dispose
  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  // 기초셋팅

  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date

  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;

// *************************************************************************************
// *************************************************************************************
// *************************** Calender 위젯 시작 합니다.  *********************************
// *************************************************************************************
// *************************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: TableCalendar(
              // ************ 달력셋팅1 ****************
              // 달력 첫화면(처음에 포커스 된 날짜 설정.) 그리고 달력에 지원할 날짜 범위 설정.
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 3, 14),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,

              // ************ 달력셋팅2 ****************
              // 다른 날짜를 찍을 수 있도록 만들기.
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                _onDaySelected(selectedDay, focusedDay);
              },
              // ************ 달력셋팅2 ****************
              // 다른 날짜를 찍을 수 있도록 만들기.
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              // 날짜 클릭시 해당 날짜의 이벤트들을 가져오는 함수
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
            ),
          ),

          //날짜찍으면 그아래 해당 날짜의 목록 보여주기.

          Card(
            color: Colors.blue[100],
            child: const SizedBox(
              width: 400,
              child: Center(
                child: Text(
                  " 날짜별 검사 내역",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
          ),
          Container(
            width: 400,
            height: 220,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 200,
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 0),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  onTap: () => {
                                    Get.to(const RSdetail(), arguments: [
                                      value[index].datetime_origin,
                                      value[index].category,
                                      value[index].rs
                                    ])
                                  },
                                  title: Text('${value[index]}'),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //---------function

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    DateTime date = DateTime(day.year, day.month, day.day);
    return kEvents[date] ?? [];
  }

  // calenfdatUtil에 있는 MAP 채우기
  _getList() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('p_userId')!;

    rsList.clear();

    var url_wholeList = Uri.parse("http://localhost:8080/wholeList?uid=$uid");
    var response_wholeList = await http.get(url_wholeList);

    //
    var dataConvertedJSON =
        json.decode(utf8.decode(response_wholeList.bodyBytes));
    List result = dataConvertedJSON['result'] ?? [];
    rsList.addAll(result ?? []);

    setList();
    print(result);

    setState(() {});
  }

// Event 채우는 함수 만들기

  setList() {
    kEventSource = {};

    for (int i = 0; i < rsList.length; i++) {
      DateTime dt_origin = DateTime.parse(rsList[i]["insertdate"]);
      DateTime dt = DateTime(dt_origin.year, dt_origin.month, dt_origin.day);
      String rs = "";
      switch (rsList[i]["result"]) {
        case 0:
          rs = "위험";

          break;
        case 1:
          rs = "일반";

          break;
      }

      String cg = "";
      switch (rsList[i]["category"]) {
        case 1:
          cg = "심혈관질환 검사";
          break;
        case 2:
          cg = "당뇨 검사 ";
          break;
        case 3:
          cg = "치매 검사";
          break;
      }

      //이벤트 리스트에 추가하기

      kEventSource[dt] = [
        ...kEventSource[dt] ?? [], // 기존 리스트 복사하기.
        Event(cg, rs, dt, rsList[i]["category"], rsList[i]["result"], dt_origin)
      ];
    } // kEventesource 채우는 for 구문 끝.
    print("eventSource 다채움");
    print(kEventSource);
    print("eventSource -> Event 채우기 전");
    print(kEvents);
    kEvents.addAll(kEventSource);
    print("eventSource -> Event 채운 후");
    print(kEvents);

    setState(() {});
  }

//선택한 날짜의 기록들을 보기위한 함수
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
      });

      _selectedEvents.value = _getEventsForDay(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
    }
  }
} //end
