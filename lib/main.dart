<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 자동 생성된 Firebase 설정 파일
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
=======

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/daily_report_screen.dart';
import 'screens/permit_screen.dart';
import 'screens/settings_screen.dart';

void main() {
>>>>>>> 992a1d246555bfc6fe6e6246615674437e67901a
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '안전관리 앱',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomeScreen(),
=======
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety App',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/dailyReport': (context) => DailyReportScreen(),
        '/permit': (context) => PermitScreen(),
        '/settings': (context) => SettingsScreen(),
      },
>>>>>>> 992a1d246555bfc6fe6e6246615674437e67901a
    );
  }
}
