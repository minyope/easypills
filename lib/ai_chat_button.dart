import 'package:flutter/material.dart';

// 테두리/주요 요소 색상 (통일)
const Color primaryColor = Color(0xFFFD4755);

// 채팅 메시지 모델
class ChatMessage {
  final String text;
  final bool isMe; // 내 메시지인지 AI 메시지인지 구분

  ChatMessage({required this.text, required this.isMe});
}

class AiChatButton extends StatefulWidget {
  final Widget child; // 대시보드 화면의 실제 내용

  const AiChatButton({super.key, required this.child});

  @override
  State<AiChatButton> createState() => _AiChatButtonState();
}

class _AiChatButtonState extends State<AiChatButton> {
  bool _isChatOpen = false;

  // 1. 한글 입력을 안정적으로 처리하기 위한 컨트롤러
  final TextEditingController _messageController = TextEditingController();

  // 2. 채팅 내용을 저장할 리스트
  final List<ChatMessage> _messages = [
    ChatMessage(text: "안녕하세요! 무엇을 도와드릴까요?", isMe: false),
  ];

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  // 3. 메시지 전송 함수
  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      // 내 메시지 추가
      _messages.add(ChatMessage(text: text, isMe: true));
      _messageController.clear(); // 입력창 비우기
    });

    // AI 응답 시뮬레이션 (1초 후)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(text: "질문하신 '$text'에 대해 분석 중입니다...", isMe: false),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose(); // 메모리 해제
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
          Positioned(right: 15.0, bottom: 100.0, child: _buildChatPopup()),
      ],
    );
  }

  Widget _buildChatPopup() {
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
          // 팝업 헤더
          Container(
            padding: const EdgeInsets.only(left: 15, right: 5),
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

          // 4. 채팅 메시지 영역 (리스트뷰 적용)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),

          // 5. 한글 입력이 잘 되는 입력창 영역
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _messageController, // 컨트롤러 연결
                    onSubmitted: (_) => _handleSendMessage(), // 엔터키 전송 허용
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    // 한글 입력 안정성을 위한 설정
                    textInputAction: TextInputAction.send,
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

  // 채팅 말풍선 위젯
  Widget _buildChatBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: msg.isMe ? primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10).copyWith(
            bottomRight: msg.isMe
                ? const Radius.circular(0)
                : const Radius.circular(10),
            bottomLeft: msg.isMe
                ? const Radius.circular(10)
                : const Radius.circular(0),
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
