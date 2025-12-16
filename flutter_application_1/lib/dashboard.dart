import 'package:flutter/material.dart';
import 'calendar_screen.dart'; // 캘린더 전체 화면
import 'profile_screen.dart'; // 내정보 화면
import 'pill_scan_screen.dart'; // 알약 스캔 화면
import 'simple_calendar_card.dart'; // 홈 화면에 들어가는 작은 달력 위젯
// import 'ai_chat_button.dart'; // AiChatButton 클래스는 아래에 포함되어 있습니다.

// ----------------------------------------------------
// 색상 정의
// ----------------------------------------------------

const Color primaryColor = Color(0xFFFD4755); // 쏙쏙 알림, 캘린더, 복용 기록 타이틀 색상
const Color backgroundColor = Color(0xFFFFFFE6); // 바탕화면 색상
const Color cardColor = Color(0xFFFFFFFF); // 요소(카드) 배경색

// ----------------------------------------------------
// DashboardScreen (메인 컨테이너 및 네비게이션)
// ----------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // 초기 선택 인덱스를 '홈' (인덱스 2)으로 설정

  // 네비게이션 바 메뉴 목록
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.camera_alt, 'label': '알약 스캔'},
    {'icon': Icons.calendar_month, 'label': '캘린더'},
    {'icon': Icons.home, 'label': '홈'},
    {'icon': Icons.map, 'label': '지도'},
    {'icon': Icons.person, 'label': '내정보'},
  ];

  // 각 메뉴에 매핑될 위젯 (AI 채팅 버튼은 홈 화면에만 적용)
  final List<Widget> _screens = [
    // 0: 카메라 화면
    const PillScanScreen(),
    // 1: 캘린더 화면
    const FullCalendarScreen(),
    // 2: 홈 화면 (AiChatButton으로 감싸서 버튼 노출)
    const AiChatButton(child: HomeScreen()),
    // 3: 지도 화면 (임시)
    const Center(child: Text('지도 화면')),
    // 4: 내정보 화면
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 요청하신 배경색 적용
      backgroundColor: backgroundColor,

      // 현재 선택된 화면 표시
      body: _screens[_selectedIndex],

      // 하단 네비게이션 바 (이동 버튼)
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item['icon']),
                label: item['label'],
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor, // 선택된 아이템 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이템 색상
        backgroundColor: cardColor, // 배경색 (요소 배경색과 동일)
        type: BottomNavigationBarType.fixed, // 아이템이 5개일 때 고정
        onTap: _onItemTapped,
      ),
    );
  }
}

// ----------------------------------------------------
// AiChatButton 위젯 (Floating Button 및 팝업)
// ----------------------------------------------------

class AiChatButton extends StatefulWidget {
  final Widget child; // 대시보드 화면의 실제 내용
  const AiChatButton({super.key, required this.child});
  @override
  State<AiChatButton> createState() => _AiChatButtonState();
}

class _AiChatButtonState extends State<AiChatButton> {
  bool _isChatOpen = false;

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. 대시보드 화면의 실제 내용 (스크롤 가능)
        widget.child,

        // 2. 고정된 AI 채팅 버튼 (오른쪽 아래)
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: FloatingActionButton(
            heroTag: "aiChatBtn",
            onPressed: _toggleChat,
            backgroundColor: primaryColor,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.smart_toy_outlined, // AI 아이콘
              color: Colors.white,
              size: 28,
            ),
          ),
        ),

        // 3. 팝업 채팅 창 (조건부 표시)
        if (_isChatOpen)
          Positioned(
            right: 15.0,
            // BottomNavigationBar 높이를 고려하여 위치 조정
            bottom: 80.0,
            child: _buildChatPopup(context),
          ),
      ],
    );
  }

  Widget _buildChatPopup(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.85,
      height: screenHeight * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // 팝업 헤더 (타이틀 및 닫기 버튼)
          Container(
            padding: const EdgeInsets.only(left: 15, right: 5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AI 쏙쏙 비서',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                // 닫기 (X) 버튼
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _toggleChat,
                ),
              ],
            ),
          ),

          // 채팅 메시지 영역
          const Expanded(
            child: Center(
              child: Text(
                'LLM 채팅 내용이 여기에 표시됩니다.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          // 입력창 영역
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: primaryColor),
                  onPressed: () {
                    // 메시지 전송 로직
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// HomeScreen (홈 화면 레이아웃)
// ----------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 섹션 타이틀 위젯
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: primaryColor, // FD4755 색상
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 각 섹션 내용 위젯 (배경색 #FFFFFF)
  Widget _buildSectionCard(String content, {double height = 70}) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
      // 요청하신 요소 배경색 #FFFFFF
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: height,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        content,
        style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
      ),
    );
  }

  // 앱 타이틀 위젯
  Widget _buildAppTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60, // 타이틀 바의 높이
      color: primaryColor, // 배경색: FD4755
      alignment: Alignment.centerLeft, // 좌측 정렬
      padding: const EdgeInsets.only(left: 24.0),
      child: const Text(
        '쏙쏙약속',
        style: TextStyle(
          color: Colors.white, // 글씨색: 흰색
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            // 0. 앱 타이틀 섹션
            _buildAppTitle(context),

            const SizedBox(height: 20),

            // 1. 알림 섹션
            _buildSectionTitle('📌 쏙쏙 알림'),
            _buildSectionCard('2025-12-15 병원 진료 예약'),
            _buildSectionCard('2025-12-19 졸업작품 발표'),

            const SizedBox(height: 20),

            // 2. 캘린더 섹션
            _buildSectionTitle('🗓️ 캘린더'),
            Container(
              height: 400, // 요청하신 높이
              margin: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 20.0,
              ),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              // SimpleCalendarCard 위젯이 들어갈 자리
              child: SimpleCalendarCard(),
            ),

            // 3. 복용 기록 섹션
            _buildSectionTitle('💊 복용 기록'),
            _buildSectionCard('아침 : 복용완료'),
            _buildSectionCard('점심 : 복용완료'),
            _buildSectionCard('저녁 : 복용전'),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
