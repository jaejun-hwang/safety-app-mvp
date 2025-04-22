import 'package:flutter/material.dart';
import '../helpers/db_helper_daily.dart';
import '../models/daily_report.dart';
import 'daily_report_detail.dart'; // ✅ 상세보기 화면 import 필요
import 'daily_report_edit.dart'; // 🛠️ 수정 화면을 사용하기 위한 import


class DailyReportListScreen extends StatefulWidget {
  const DailyReportListScreen({super.key});

  @override
  State<DailyReportListScreen> createState() => _DailyReportListScreenState();
}

class _DailyReportListScreenState extends State<DailyReportListScreen> {
  late Future<List<DailyReport>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = DailyDBHelper.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일일작업일보 목록')),
      body: FutureBuilder<List<DailyReport>>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('작성된 일보가 없습니다.'));
          }

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text(report.siteName),
                subtitle: Text('${report.date.split("T").first} / 작업자 ${report.workerCount}명'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DailyReportEditScreen(report: report),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
