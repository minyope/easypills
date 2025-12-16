import 'package:flutter/material.dart';

// 테두리/주요 요소 색상 (통일)
const Color primaryColor = Color(0xFFFD4755);

// ----------------------------------------------------
// AI 채팅 버튼 및 팝업 관리 위젯
// ----------------------------------------------------
class AiChatButton extends StatefulWidget {
  // 이 위젯은 부모 위젯 (DashboardScreen 등)의 body에 Stack으로 감싸져 사용됩니다.
  final Widget child; // 대시보드 화면의 실제 내용 (SingleChildScrollView 등)

  const AiChatButton({super.key, required this.child});

  @override
  State<AiChatButton> createState() => _AiChatButtonState();
}

class _AiChatButtonState extends State<AiChatButton> {
  // 팝업 창의 열림/닫힘 상태
  bool _isChatOpen = false;

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stack 위젯을 사용하여 자식 위젯(대시보드 내용) 위에 버튼과 팝업을 겹쳐서 표시합니다.
    return Stack(
      children: [
        // 1. 대시보드 화면의 실제 내용 (스크롤 가능)
        widget.child,

        // 2. 고정된 AI 채팅 버튼 (오른쪽 아래)
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: FloatingActionButton(
            heroTag: "aiChatBtn", // 여러 FAB 사용 시 필요
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
            bottom: 100.0, // 버튼보다 위에 표시
            child: _buildChatPopup(),
          ),
      ],
    );
  }

  // 채팅 팝업 창 위젯
  Widget _buildChatPopup() {
    // 화면 너비의 약 80%, 높이의 50%를 차지하는 팝업
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

          // 채팅 메시지 영역 (스크롤 가능)
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
