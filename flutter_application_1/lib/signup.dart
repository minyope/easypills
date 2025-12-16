import 'package:flutter/material.dart';

// 회원가입 화면 위젯
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 텍스트 필드 관리를 위한 컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // 회원가입 버튼이 눌렸을 때 실행될 함수
  void _handleSignUpComplete() {
    // 1. 간단한 유효성 검사 (예시: 비밀번호 일치 여부 확인)
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    // 2. 입력된 모든 데이터 출력
    String id = _idController.text;
    String name = _nameController.text;
    String birth = _birthDateController.text;
    String phone = _phoneController.text;

    print('회원가입 정보: ID: $id, 이름: $name, 생년월일: $birth, 전화번호: $phone');

    // 3. 실제 서버 통신 및 회원가입 완료 로직을 여기에 구현합니다.

    // 4. 회원가입 성공 메시지 표시 및 이전 화면으로 돌아가기 (예시)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다!')));
    // Navigator.pop(context); // 이전 화면(로그인 화면)으로 돌아가기
  }

  // 위젯이 제거될 때 컨트롤러 메모리를 해제합니다.
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        // 스크롤 가능하게 하여 키보드 입력 시 화면 넘침 방지
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 10),

            // 1. 아이디 입력
            _buildTextField(
              _idController,
              '아이디',
              Icons.email,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // 2. 비밀번호 입력
            _buildPasswordField(_passwordController, '비밀번호 입력', Icons.lock),
            const SizedBox(height: 20),

            // 3. 비밀번호 재입력
            _buildPasswordField(
              _confirmPasswordController,
              '비밀번호 재입력',
              Icons.lock,
            ),
            const SizedBox(height: 30),

            // 4. 이름
            _buildTextField(
              _nameController,
              '이름',
              Icons.person,
              TextInputType.name,
            ),
            const SizedBox(height: 20),

            // 5. 생년월일
            _buildTextField(
              _birthDateController,
              '생년월일 (YYYYMMDD)',
              Icons.calendar_today,
              TextInputType.datetime,
            ),
            const SizedBox(height: 20),

            // 6. 전화번호
            _buildTextField(
              _phoneController,
              '전화번호 (- 없이 입력)',
              Icons.phone,
              TextInputType.phone,
            ),
            const SizedBox(height: 50),

            // 7. 회원가입 완료 버튼
            ElevatedButton(
              onPressed: _handleSignUpComplete,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                backgroundColor: const Color(0xFFFD4755),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), // 버튼 모서리를 둥글게
              ),
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }

  // 일반 텍스트 필드 위젯을 만드는 헬퍼 함수
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

  // 비밀번호 입력 필드 위젯을 만드는 헬퍼 함수
  Widget _buildPasswordField(
    TextEditingController controller,
    String labelText,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      obscureText: true, // 비밀번호 숨김 처리
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
