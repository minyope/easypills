import 'package:flutter/material.dart';
import 'calendar_screen.dart'; // 캘린더 전체 화면
import 'profile_screen.dart'; // 내정보 화면
import 'pill_scan_screen.dart'; // 알약 스캔 화면
import 'simple_calendar_card.dart'; // 홈 화면용 작은 달력 위젯
import 'map_screen.dart';

// ----------------------------------------------------
// 색상 및 모델 정의
// ----------------------------------------------------

const Color primaryColor = Color(0xFFFD4755);
const Color backgroundColor = Color(0xFFFFFFE6);
const Color cardColor = Color(0xFFFFFFFF);

// 채팅 메시지 데이터 모델
class ChatMessage {
  final String text;
  final bool isMe;
  ChatMessage({required this.text, required this.isMe});
}

// ----------------------------------------------------
// DashboardScreen (메인 컨테이너)
// ----------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // 초기 '홈' 설정

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.camera_alt, 'label': '알약 스캔'},
    {'icon': Icons.calendar_month, 'label': '캘린더'},
    {'icon': Icons.home, 'label': '홈'},
    {'icon': Icons.map, 'label': '지도'},
    {'icon': Icons.person, 'label': '내정보'},
  ];

  final List<Widget> _screens = [
    const PillScanScreen(),
    const FullCalendarScreen(),
    const AiChatButton(child: HomeScreen()), // 홈 화면만 AI 비서 적용
    const MapScreen(),
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
      backgroundColor: backgroundColor,
      body: _screens[_selectedIndex],
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
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: cardColor,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ----------------------------------------------------
// AiChatButton 위젯
// ----------------------------------------------------

class AiChatButton extends StatefulWidget {
  final Widget child;
  const AiChatButton({super.key, required this.child});

  @override
  State<AiChatButton> createState() => _AiChatButtonState();
}

class _AiChatButtonState extends State<AiChatButton> {
  bool _isChatOpen = false;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: "안녕하세요! '쏙쏙 비서'입니다. 무엇을 도와드릴까요?", isMe: false),
  ];

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isMe: true));
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(text: "'$text'에 대한 정보를 분석 중입니다...", isMe: false),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: FloatingActionButton(
            heroTag: "aiChatBtn",
            onPressed: _toggleChat,
            backgroundColor: primaryColor,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        if (_isChatOpen)
          Positioned(
            right: 15.0,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
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
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _toggleChat,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _messageController,
                    onSubmitted: (_) => _handleSendMessage(),
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: primaryColor),
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomRight: msg.isMe ? Radius.zero : const Radius.circular(12),
            bottomLeft: msg.isMe ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// HomeScreen (홈 화면 레이아웃 - StatefulWidget으로 변경됨)
// ----------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 복용 상태를 저장하는 맵
  final Map<String, bool> _pillStatus = {
    '09:00 (아침)': true, // 초기값 예시
    '13:00 (점심)': true,
    '18:00 (저녁)': false,
  };

  void _togglePill(String time) {
    setState(() {
      _pillStatus[time] = !(_pillStatus[time]!);
    });
  }

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

  // 일반 알림 카드
  Widget _buildSectionCard(String content) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
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
      height: 70,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        content,
        style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
      ),
    );
  }

  // 인터랙티브 복용 체크 카드
  Widget _buildPillCheckCard(String time) {
    bool isDone = _pillStatus[time]!;
    return GestureDetector(
      onTap: () => _togglePill(time),
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
                  time,
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

  Widget _buildAppTitle(BuildContext context) {
    return Container(
      width: double.infinity, // 전체 너비 차지
      height: 60, // 타이틀 바 높이
      color: primaryColor, // FD4755 배경색
      alignment: Alignment.center, // 텍스트를 정중앙에 배치
      child: const Text(
        '쏙쏙약속',
        style: TextStyle(
          color: Colors.white, // 텍스트 흰색
          fontSize: 22, // 폰트 크기 (약간 조정)
          fontWeight: FontWeight.bold, // 굵게
          letterSpacing: 1.2, // 글자 간격 (선택사항)
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
            _buildAppTitle(context),
            const SizedBox(height: 20),
            _buildSectionTitle('📌 쏙쏙 알림'),
            _buildSectionCard('2025-12-15 병원 진료 예약'),
            _buildSectionCard('2025-12-19 졸업작품 발표'),
            const SizedBox(height: 20),
            _buildSectionTitle('🗓️ 캘린더'),
            Container(
              height: 400,
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
              child: const SimpleCalendarCard(),
            ),
            _buildSectionTitle('💊 복용 기록'),
            _buildPillCheckCard('09:00 (아침)'),
            _buildPillCheckCard('13:00 (점심)'),
            _buildPillCheckCard('18:00 (저녁)'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
