import 'package:flutter/material.dart';
import 'daily_report_screen.dart';
import 'work_permit_screen.dart';
import 'risk_assessment_screen.dart';
import 'photo_log_screen.dart';
import 'access_qr_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(child: Text('LT삼보')),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text('📅 오늘 할 일', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('• 일일작업일보 작성'),
                  const Text('• 고소작업 점검'),
                  const SizedBox(height: 20),
                  const Text('📝 문서 작성하기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('일일작업일보'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => DailyReportScreen()));
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.build),
                    label: const Text('작업허가서'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => WorkPermitForm()));
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.warning),
                    label: const Text('위험성평가'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RiskAssessmentScreen()));
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('사진기록'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoLogScreen()));
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text('QR 출입관리'),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AccessQRScreen()));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 👇 하단 캐릭터 이미지
            Image.asset(
              'assets/images/welcome_character.png',
              height: 400, // 원하는 크기로 조절
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
