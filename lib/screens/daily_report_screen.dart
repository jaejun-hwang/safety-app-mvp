import 'package:flutter/material.dart';
import 'daily_report_form.dart';

class DailyReportScreen extends StatelessWidget {
  const DailyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // ✅ const 제거
      body: const DailyReportForm(),
    );
  }
}
