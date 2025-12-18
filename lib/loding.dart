import 'package:flutter/material.dart';
import 'dart:async'; // Timer를 사용하기 위해 import 합니다.

// 다음 화면 (메인 화면)을 임시로 정의합니다. 실제 앱에서는 여기에 메인 화면 위젯을 넣으세요.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메인 화면')),
      body: const Center(
        child: Text('여기가 앱의 메인 콘텐츠입니다!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2초 후에 HomeScreen으로 이동
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // 흰색 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지
            Image(
              image: AssetImage('img/ico/ico.png'), // 이미지 경로
              width: 150, // 로고 너비 (원하는 크기로 조절하세요)
              height: 150, // 로고 높이 (원하는 크기로 조절하세요)
            ),
            SizedBox(height: 20), // 로고와 텍스트 사이 간격
            Text(
              '로딩 중...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30), // 텍스트와 하단 로딩바 사이 간격
            // 로딩 인디케이터 (선택 사항)
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // 로딩바 색상
            ),
          ],
        ),
      ),
    );
  }
}
