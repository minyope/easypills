import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 1. API 통신을 담당하는 클래스 (상단 혹은 별도 파일)
class ApiService {
  // 실제 서버 주소로 변경하세요 (예: http://192.168.0.10:8080)
  static const String baseUrl = "https://your-api-server.com";

  static Future<http.Response> postSignUp(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/signup'); // 서버의 회원가입 엔드포인트
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );
  }
}

// 2. 회원가입 화면 위젯
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // 회원가입 버튼 로직 (비동기 async 추가)
  void _handleSignUpComplete() async {
    // 1. 간단한 유효성 검사
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('아이디와 비밀번호를 입력해주세요.');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('비밀번호가 일치하지 않습니다.');
      return;
    }

    // 로딩 인디케이터 표시
    _showLoadingDialog();

    // 2. 서버로 보낼 데이터 구성
    Map<String, dynamic> signUpData = {
      'userId': _idController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
      'birth': _birthDateController.text,
      'phone': _phoneController.text,
    };

    try {
      // 3. 실제 API 호출
      final response = await ApiService.postSignUp(signUpData);

      // 로딩 창 닫기
      if (mounted) Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공 시
        _showSnackBar('회원가입이 완료되었습니다!');
        if (mounted) Navigator.pop(context); // 가입 완료 후 이전 화면으로 이동
      } else {
        // 서버 에러 발생 시
        _showSnackBar('가입 실패: ${response.body}');
      }
    } catch (e) {
      // 네트워크 연결 에러 등
      if (mounted) Navigator.pop(context);
      _showSnackBar('서버와 통신 중 오류가 발생했습니다.');
      print('Error: $e');
    }
  }

  // 메시지 표시용 헬퍼
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // 로딩 다이얼로그
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
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: const Color(0xFFFD4755),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10),
            _buildTextField(
              _idController,
              '아이디',
              Icons.email,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildPasswordField(_passwordController, '비밀번호 입력', Icons.lock),
            const SizedBox(height: 20),
            _buildPasswordField(
              _confirmPasswordController,
              '비밀번호 재입력',
              Icons.lock,
            ),
            const SizedBox(height: 30),
            _buildTextField(
              _nameController,
              '이름',
              Icons.person,
              TextInputType.name,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _birthDateController,
              '생년월일 (YYYYMMDD)',
              Icons.calendar_today,
              TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              _phoneController,
              '전화번호 (- 없이 입력)',
              Icons.phone,
              TextInputType.phone,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _handleSignUpComplete,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: const Color(0xFFFD4755),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon,
    TextInputType keyboardType,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String labelText,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
