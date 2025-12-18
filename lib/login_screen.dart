import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'signup.dart';
import 'dashboard.dart';

// 1. API 통신 모듈 (주석 유지)
class ApiService {
  static const String baseUrl = "https://your-api-server.com";

  static Future<http.Response> postLogin(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"email": email, "password": password}),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 로직
  void _handleLogin() async {
    final String email = _idController.text.trim();
    final String password = _passwordController.text.trim();

    // 1. 최소 유효성 검사 (입력 확인)
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('아이디와 비밀번호를 모두 입력해주세요.');
      return;
    }

    /* -----------------------------------------------------------
       [나중에 서버 연동 시 주석 해제하세요]
    _showLoadingDialog();
    try {
      final response = await ApiService.postLogin(email, password);
      if (mounted) Navigator.pop(context); // 로딩창 닫기

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('토큰: ${responseData['token']}');
        // ... 성공 로직 ...
      } else {
        _showSnackBar('로그인 정보가 일치하지 않습니다.');
        return; 
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar('서버와 연결할 수 없습니다.');
      return;
    }
    ----------------------------------------------------------- */

    // 💡 지금은 바로 통과! 대시보드로 이동
    if (mounted) {
      _showSnackBar('테스트 모드로 진입합니다.');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  void _handleSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  // 메시지 표시용 헬퍼
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // 로딩 다이얼로그 (테스트 모드에서는 호출되지 않음)
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFD4755);

    return Scaffold(
      appBar: AppBar(
        title: const Text('쏙쏙약속 로그인'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 로고 아이콘
              Center(
                child: Icon(
                  Icons.medication_liquid_outlined,
                  size: 100,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 50),

              // 아이디 입력
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: '아이디 (Email)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 비밀번호 입력
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

              // 로그인 버튼
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('로그인'),
              ),
              const SizedBox(height: 20),

              const Divider(thickness: 1),
              const SizedBox(height: 20),

              // 회원가입 버튼
              TextButton(
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
