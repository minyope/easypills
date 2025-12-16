import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 배경 색상
const Color backgroundColor = Color(0xFFFFFFE6);
// 테두리/주요 요소 색상
const Color primaryColor = Color(0xFFFD4755);

// 간단한 일정 모델 (다른 파일에서 import하거나 여기에 복사해야 합니다.)
class Event {
  final String title;
  final TimeOfDay time;

  const Event(this.title, this.time);

  @override
  String toString() {
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$title (${time.hour}:$minute)';
  }
}

// ----------------------------------------------------
// 전체 화면 캘린더 위젯 (이전 요청의 풀 스크린 구조)
// ----------------------------------------------------
class FullCalendarScreen extends StatefulWidget {
  // FullCalendarScreen으로 이름 변경
  const FullCalendarScreen({super.key});

  @override
  State<FullCalendarScreen> createState() => _FullCalendarScreenState();
}

class _FullCalendarScreenState extends State<FullCalendarScreen> {
  // 캘린더 컨트롤러
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 일정 데이터
  final Map<DateTime, List<Event>> _events = {
    DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ): const [
      Event('아침 회의', TimeOfDay(hour: 9, minute: 0)),
      Event('프로젝트 마감', TimeOfDay(hour: 17, minute: 30)),
    ],
    DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    ): const [
      Event('운동', TimeOfDay(hour: 19, minute: 0)),
    ],
  };

  // 특정 날짜의 일정을 가져오는 함수
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  // 일정 추가 다이얼로그
  void _addEvent(BuildContext context) async {
    final titleController = TextEditingController();
    TimeOfDay? selectedTime = TimeOfDay.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('일정 추가 (${_selectedDay.month}월 ${_selectedDay.day}일)'),
          content: StatefulBuilder(
            // TimePicker 선택 후 시간을 업데이트하기 위해 StatefulBuilder 사용
            builder: (BuildContext context, StateSetter setStateSetter) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: '일정 제목'),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon: const Icon(Icons.access_time, color: primaryColor),
                    label: Text(
                      '시간: ${selectedTime!.format(context)}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime!,
                      );
                      if (picked != null) {
                        setStateSetter(() {
                          // StatefulBuilder의 setStateSetter 사용
                          selectedTime = picked;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && selectedTime != null) {
                  final newEvent = Event(titleController.text, selectedTime!);
                  final normalizedDate = DateTime.utc(
                    _selectedDay.year,
                    _selectedDay.month,
                    _selectedDay.day,
                  );

                  setState(() {
                    // 화면 setState로 캘린더 마커 업데이트
                    _events.update(
                      normalizedDate,
                      (existingEvents) => [...existingEvents, newEvent],
                      ifAbsent: () => [newEvent],
                    );
                    _events[normalizedDate]!.sort(
                      (a, b) =>
                          a.time.hour * 60 +
                          a.time.minute -
                          (b.time.hour * 60 + b.time.minute),
                    );
                  });

                  Navigator.pop(context); // 다이얼로그 닫기
                }
              },
              child: const Text('추가', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 현재 선택된 날짜의 일정을 가져옵니다.
    final selectedEvents = _getEventsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: backgroundColor,
      // 1. 앱바 (타이틀 및 + 버튼)
      appBar: AppBar(
        title: const Text('🗓️ 캘린더'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          // 일정 추가 버튼
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => _addEvent(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 2. 캘린더 위젯
          _buildCalendar(),

          const Divider(height: 1, thickness: 1, color: Colors.grey),

          // 3. 선택된 날짜의 일정 목록 (Expanded로 남은 공간 차지)
          Expanded(child: _buildEventList(selectedEvents)),
        ],
      ),
    );
  }

  // TableCalendar 위젯 구축
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2), // 테두리 색상 적용
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: TableCalendar<Event>(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay, // 일정 로드 함수 연결
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

        // 캘린더 UI 스타일 설정
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
          rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: const BoxDecoration(
            color: Colors.pink, // 오늘 날짜 배경
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: primaryColor, // 선택된 날짜 배경
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0.7), // 일정 마커 색상
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // 선택된 날짜의 일정 목록 위젯 구축
  Widget _buildEventList(List<Event> selectedEvents) {
    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          '${_selectedDay.month}월 ${_selectedDay.day}일에는 일정이 없습니다.',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: primaryColor, width: 0.5),
          ),
          child: ListTile(
            leading: Icon(Icons.label, color: primaryColor.withOpacity(0.8)),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '시간: ${event.time.format(context)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        );
      },
    );
  }
}
