import 'package:flutter/material.dart';
import 'signup.dart'; // SignUpScreen을 사용하기 위한 가정된 파일
import 'dashboard.dart'; // DashboardScreen으로 이동하기 위해 import

// 로그인 화면 위젯
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 텍스트 필드 값을 저장하고 관리하기 위한 컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 버튼이 눌렸을 때 실행될 함수
  void _handleLogin() {
    // 실제 로그인 로직을 여기에 구현합니다. (예: 서버 통신, 유효성 검사 등)
    // 현재는 ID/PW 입력 여부와 관계없이 성공했다고 가정하고 대시보드로 이동합니다.

    // 💡 화면 이동 로직:
    // Navigator.pushReplacement를 사용하여 현재 화면(로그인)을 대시보드 화면으로 교체합니다.
    // 이렇게 하면 대시보드에서 뒤로 가기를 눌러도 로그인 화면으로 돌아가지 않습니다.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  // 회원가입 버튼이 눌렸을 때 실행될 함수
  void _handleSignUp() {
    // 💡 회원가입 화면으로 이동하는 로직
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(), // SignUpScreen으로 이동
      ),
    );
  }

  // 위젯이 제거될 때 컨트롤러 메모리를 해제합니다.
  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 네이버 앱바 색상과 유사하게 primaryColor를 설정합니다.
    const Color primaryColor = Color(0xFFFD4755);

    return Scaffold(
      appBar: AppBar(
        title: const Text('쏙쏙약속 로그인'),
        // 배경색을 FD4755와 어울리도록 명확하게 설정했습니다.
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        // 키보드가 올라올 때 오버플로우 방지를 위해 SingleChildScrollView 사용
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 💡 로고 자리
              Center(
                child: Icon(
                  Icons.medication_liquid_outlined,
                  size: 100,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 50),

              // 1. 아이디 입력 필드
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: '아이디 (ID)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 2. 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호 (Password)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 30),

              // 3. 로그인 버튼
              ElevatedButton(
                // 💡 _handleLogin 함수 연결 (Dashboard로 이동)
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: primaryColor, // 버튼 배경색
                  foregroundColor: Colors.white, // 버튼 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 20),

              const Divider(thickness: 1), // 구분선 추가
              const SizedBox(height: 20),

              // 4. 회원가입 버튼
              TextButton(
                // 💡 _handleSignUp 함수 연결 (SignUpScreen으로 이동)
                onPressed: _handleSignUp,
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ⚠️ 참고: SignUpScreen 파일이 없으므로 임시로 정의합니다.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: const Center(child: Text('회원가입 화면입니다.')),
    );
  }
}
