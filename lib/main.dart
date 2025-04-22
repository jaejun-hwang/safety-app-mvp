import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/daily_report_screen.dart';
import 'screens/permit_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/daily_report_list.dart'; // ✅ 리스트 화면 import 추가

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '안전관리 앱',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dailyReport': (context) => const DailyReportScreen(),
        '/dailyReportList': (context) => const DailyReportListScreen(), // ✅ 목록 화면 라우트 등록
        '/permit': (context) => const PermitScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
