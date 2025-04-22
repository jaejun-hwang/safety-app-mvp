import 'package:flutter/material.dart';
import '../models/daily_report.dart';
import '../helpers/db_helper_daily.dart';
import 'daily_report_edit.dart'; // ✏️ 수정 화면

class DailyReportDetailScreen extends StatelessWidget {
  final DailyReport report;

  const DailyReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일보 상세 보기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('날짜: ${report.date.split("T").first}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('현장명: ${report.siteName}'),
            Text('작업내용: ${report.workDescription}'),
            Text('작업자 수: ${report.workerCount}명'),
            Text('날씨: ${report.weather}'),
            Text('특이사항: ${report.issues}'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DailyReportEditScreen(report: report),
                      ),
                    );
                    if (updated == true && context.mounted) {
                      Navigator.pop(context); // 수정 후 목록으로 돌아감
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('수정'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('삭제 확인'),
                        content: const Text('정말로 이 일보를 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('삭제', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await DailyDBHelper.deleteReport(report.id!);
                      Navigator.pop(context); // 삭제 후 목록으로 복귀
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
