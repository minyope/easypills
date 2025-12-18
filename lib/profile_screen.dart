import 'package:flutter/material.dart';

// 임시 데이터 모델 (실제 앱에서는 서버나 데이터베이스에서 가져옵니다)
class UserData {
  final String name;
  final String birthday;
  final int age;
  final String userId;
  final List<String> currentMedications;
  final List<String> pastRecords;

  UserData({
    required this.name,
    required this.birthday,
    required this.age,
    required this.userId,
    required this.currentMedications,
    required this.pastRecords,
  });
}

// ----------------------------------------------
// 내 정보 화면 위젯
// ----------------------------------------------

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // 임시 사용자 데이터 (실제 데이터로 교체하세요)
  final UserData user = UserData(
    name: "김민엽",
    birthday: "2004년 07월 03일",
    age: 22,
    userId: "admin",
    currentMedications: ["타이레놀 1일 1회"],
    pastRecords: ["2025.03.01: 오른손 검지 수술"],
  );

  // 설정 페이지로 이동하는 함수 (임시)
  void _goToSettings(BuildContext context) {
    // 실제로는 Navigator.push를 사용하여 설정/수정 페이지로 이동합니다.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(), // ⚠️ SettingsScreen 위젯 필요
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Color(0xFFFD4755),
        elevation: 0,
        actions: [
          // 톱니바퀴 아이콘: 설정/수정 페이지로 이동
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _goToSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. 프로필 상단 영역 (아이콘, 이름)
            _buildProfileHeader(context),

            const Divider(height: 1, color: Color(0xFFFD4755)),

            // 2. 기본 정보 섹션
            _buildInfoSection(
              title: '기본 정보',
              children: [
                _buildInfoRow(Icons.person_outline, '이름', user.name),
                _buildInfoRow(Icons.cake_outlined, '생년월일', user.birthday),
                _buildInfoRow(Icons.watch_later_outlined, '나이', '${user.age}세'),
                _buildInfoRow(Icons.badge_outlined, '아이디', user.userId),
              ],
            ),

            // 3. 복용 중인 약 기록 섹션
            _buildListSection(
              title: '복용 중인 약',
              icon: Icons.medical_services_outlined,
              items: user.currentMedications,
              emptyMessage: '현재 복용 중인 약이 없습니다.',
            ),

            // 4. 기타 건강 기록 섹션
            _buildListSection(
              title: '과거 건강 기록',
              icon: Icons.history,
              items: user.pastRecords,
              emptyMessage: '기록된 과거 건강 정보가 없습니다.',
            ),
          ],
        ),
      ),
    );
  }

  // 프로필 상단 영역 위젯
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFFD4755),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 정보 섹션 구축 위젯
  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFD4755),
              ),
            ),
          ),
          ...children, // 목록 확장
        ],
      ),
    );
  }

  // 개별 정보 항목 행 위젯
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFFFD4755), size: 20),
          const SizedBox(width: 15),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xFFFD4755)),
            ),
          ),
        ],
      ),
    );
  }

  // 목록 형태의 정보 섹션 위젯 (약 기록, 건강 기록 등)
  Widget _buildListSection({
    required String title,
    required IconData icon,
    required List<String> items,
    required String emptyMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFFFD4755), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFD4755),
                  ),
                ),
              ],
            ),
          ),
          items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    emptyMessage,
                    style: const TextStyle(color: Color(0xFFFD4755)),
                  ),
                )
              : Column(
                  children: items
                      .map(
                        (item) => ListTile(
                          leading: const Icon(Icons.circle, size: 8),
                          title: Text(item),
                          dense: true,
                        ),
                      )
                      .toList(),
                ),
          const SizedBox(height: 10),
          const Divider(height: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}

// ⚠️ 참고: 설정 페이지는 별도로 구현해야 합니다.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정 및 정보 수정'),
        backgroundColor: Color(0xFFFD4755),
      ),
      body: const Center(child: Text('여기에 개인 정보 수정, 알림 설정 등의 위젯을 구현합니다.')),
    );
  }
}
