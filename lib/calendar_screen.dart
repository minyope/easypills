import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 배경 색상 및 테마 컬러
const Color backgroundColor = Color(0xFFFFFFE6);
const Color primaryColor = Color(0xFFFD4755);
const Color cardColor = Color(0xFFFFFFFF);

// 복용 일정 모델
class PillEvent {
  final String timeText; // "09:00 (아침)" 등 표시 텍스트
  bool isTaken; // 복용 여부

  PillEvent({required this.timeText, this.isTaken = false});
}

class FullCalendarScreen extends StatefulWidget {
  const FullCalendarScreen({super.key});

  @override
  State<FullCalendarScreen> createState() => _FullCalendarScreenState();
}

class _FullCalendarScreenState extends State<FullCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // 1. 날짜별 복용 데이터 관리 (전체 데이터 저장소)
  // 모든 날짜에 대해 기본적으로 9시, 13시, 18시 일정을 생성합니다.
  final Map<DateTime, List<PillEvent>> _pillRecords = {};

  @override
  void initState() {
    super.initState();
    // 현재 달의 데이터를 예시로 미리 생성 (실제 앱에서는 필요할 때 생성)
    _generateDefaultPillData(_focusedDay);
  }

  // 해당 날짜에 데이터가 없으면 기본 3타임 일정을 만듭니다.
  List<PillEvent> _getOrInitPillData(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    if (!_pillRecords.containsKey(normalizedDay)) {
      _pillRecords[normalizedDay] = [
        PillEvent(timeText: '09:00 (아침)'),
        PillEvent(timeText: '13:00 (점심)'),
        PillEvent(timeText: '18:00 (저녁)'),
      ];
    }
    return _pillRecords[normalizedDay]!;
  }

  void _generateDefaultPillData(DateTime focusedDay) {
    // 초기 실행 시 현재 달 위주로 데이터를 로드하는 시뮬레이션
  }

  // 2. 캘린더 마커 표시 로직: 모든 약을 먹었을 때만 동그라미 표시
  List<dynamic> _getMarkerLoader(DateTime day) {
    final pills = _getOrInitPillData(day);
    // 모든 약이 복용 완료(isTaken == true) 상태인지 확인
    bool allTaken = pills.every((pill) => pill.isTaken);

    // 모두 먹었을 때만 리스트에 아이템을 하나 담아 마커를 그리게 함
    // 하나라도 안 먹었으면 빈 리스트를 반환하여 마커를 표시하지 않음
    return allTaken ? ['AllTaken'] : [];
  }

  // 3. 복용 상태 변경 함수
  void _togglePillStatus(PillEvent pill) {
    setState(() {
      pill.isTaken = !pill.isTaken;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPills = _getOrInitPillData(_selectedDay);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          '🗓️ 복용 캘린더',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 상단 캘린더 영역
          _buildCalendar(),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '모든 약을 복용하면 캘린더에 표시됩니다.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 하단 복용 기록 리스트 (대시보드 디자인 적용)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                _buildSectionTitle(
                  '${_selectedDay.month}월 ${_selectedDay.day}일 복용 기록',
                ),
                ...currentPills
                    .map((pill) => _buildPillCheckCard(pill))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,

        // ✨ 핵심: 마커 로더 연결
        eventLoader: _getMarkerLoader,

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) => setState(() => _calendarFormat = format),

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
          markerDecoration: const BoxDecoration(
            color: primaryColor, // 약을 다 먹었을 때 표시될 색상
            shape: BoxShape.circle,
          ),
          // 마커 위치 및 크기 조정
          markersAlignment: Alignment.bottomCenter,
          todayDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // --- 대시보드 스타일 컴포넌트 ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPillCheckCard(PillEvent pill) {
    bool isDone = pill.isTaken;
    return GestureDetector(
      onTap: () => _togglePillStatus(pill),
      child: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? primaryColor : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  pill.timeText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDone ? primaryColor : Colors.black87,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDone ? primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isDone ? '복용 완료' : '복용 전',
                style: TextStyle(
                  color: isDone ? Colors.white : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
