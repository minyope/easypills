import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 캘린더 한국어 지원을 위해 추가

import 'login_screen.dart';
import 'dashboard.dart';

// import 'calendar_screen.dart'; // 캘린더 화면 파일이 있다면 import하세요.

// ⚠️ 참고: 만약 calendar_screen.dart 파일을 따로 만들지 않고,
// 이전에 제공된 코드를 이 main.dart에 바로 넣을 경우 이 import는 제거해야 합니다.
// 여기서는 별도의 파일로 존재한다고 가정하고 진행합니다.

// 캘린더 화면의 한국어 로케일 사용을 위해 CalendarScreen 파일에서 정의했던
// TableCalendar를 여기서 사용한다고 가정하고 localizationsDelegates를 추가합니다.

void main() {
  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '쏙쏙약속',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFD4755)),
        useMaterial3: true,
      ),

      // 캘린더 위젯(table_calendar)의 한국어 로케일 지원을 위한 설정 추가
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // 영어
        Locale('ko', ''), // 한국어 (필수)
      ],

      // 앱의 시작 화면을 LoginScreen으로 설정합니다.
      home: const LoginScreen(),

      // 라우트를 정의하여 네비게이션을 명확히 합니다.
      routes: {
        // 로그인 성공 후 이동할 대시보드 화면
        '/dashboard': (context) => const DashboardScreen(),
        // 캘린더 화면 (calendar_screen.dart 파일 import 필요)
        // '/calendar': (context) => const CalendarScreen(),
      },
    );
  }
}

// ⚠️ 주의: 기존의 MyHomePage와 _MyHomePageState 클래스는 제거하거나 주석 처리하세요.
// 이전에 작성했던 카운터 앱 코드는 이제 필요 없습니다.
