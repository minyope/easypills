import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 테두리/주요 요소 색상 (통일)
const Color primaryColor = Color(0xFFFD4755);

// ----------------------------------------------------
// 대시보드 카드에 삽입될 단순 날짜 표시 캘린더 위젯
// ----------------------------------------------------
class SimpleCalendarCard extends StatefulWidget {
  const SimpleCalendarCard({super.key});

  @override
  State<SimpleCalendarCard> createState() => _SimpleCalendarCardState();
}

class _SimpleCalendarCardState extends State<SimpleCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 대시보드 카드는 월별 포맷으로 고정합니다.
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container는 대시보드에서 이미 300 높이로 감싸져 있으므로 내부 마진만 설정합니다.
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2), // 테두리 색상 적용
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: TableCalendar(
        locale: 'ko_KR', // 한국어 설정
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,

        // 일정 로드 기능을 제거하여 단순화
        eventLoader: null,

        // 날짜 선택 상태 관리
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              // ⭐️ API 연동 포인트: 여기서 선택된 날짜(_selectedDay)를 기반으로 데이터를 로드합니다.
            });
          }
        },

        // 탐색 기능만 활성화하고 UI 변경은 최소화
        onFormatChanged: (format) {
          /* do nothing */
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
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: primaryColor,
            size: 20,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: primaryColor,
            size: 20,
          ),
        ),
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
