import 'package:flutter/material.dart';
import 'daily_report_screen.dart';
import 'work_permit_screen.dart';
import 'risk_assessment_screen.dart';
import 'photo_log_screen.dart';
import 'access_qr_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // ✅ 생성자에 const 키워드 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'), // ✅ Text 위젯에도 const 추가
        actions: const [ // ✅ actions 리스트에도 const 추가
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(child: Text('LT삼보')), // ✅ Text 위젯에도 const 추가
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('📅 오늘 할 일', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // ✅ const 추가
            const SizedBox(height: 8), // ✅ const 추가
            const Text('• 일일작업일보 작성'), // ✅ const 추가
            const Text('• 고소작업 점검'), // ✅ const 추가
            const SizedBox(height: 20), // ✅ const 추가
            const Text('📝 문서 작성하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // ✅ const 추가
            const SizedBox(height: 8), // ✅ const 추가
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today), // ✅ const 추가
              label: const Text('일일작업일보'), // ✅ const 추가
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DailyReportScreen()));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.build), // ✅ const 추가
              label: const Text('작업허가서'), // ✅ const 추가
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => WorkPermitForm()));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.warning), // ✅ const 추가
              label: const Text('위험성평가'), // ✅ const 추가
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RiskAssessmentScreen()));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt), // ✅ const 추가
              label: const Text('사진기록'), // ✅ const 추가
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoLogScreen()));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code), // ✅ const 추가
              label: const Text('QR 출입관리'), // ✅ const 추가
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AccessQRScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}