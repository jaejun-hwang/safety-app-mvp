import 'package:flutter/material.dart';
import '../models/work_permit.dart';
import 'work_permit_edit.dart'; // 🔧 수정 화면 import
import '../helpers/db_helper.dart';

class WorkPermitDetailScreen extends StatelessWidget {
  final WorkPermit permit;

  const WorkPermitDetailScreen({super.key, required this.permit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('작업허가서 상세')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('공사명: ${permit.constructionName}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('작업위치: ${permit.location}'),
            Text('작업내용: ${permit.content}'),
            Text('작업일시: ${permit.date.split("T").first}'),
            Text('책임자: ${permit.supervisor}'),
            Text('작업자 수: ${permit.workerCount}'),
            Text('안전조치 확인: ${permit.safetyChecked ? '예' : '아니오'}'),
            Text('특이사항: ${permit.notes}'),
            const SizedBox(height: 24),

            // 🔧 수정 버튼
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkPermitEditScreen(permit: permit),
                    ),
                  );
                  if (updated == true && context.mounted) {
                    Navigator.pop(context); // 수정 완료되면 목록으로 돌아감
                  }
                },
                child: const Text('수정'),
              ),
            ),
            const SizedBox(height: 10),

            // ❌ 삭제 버튼
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('삭제 확인'),
                      content: const Text('정말로 이 작업허가서를 삭제하시겠습니까?'),
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
                    await DBHelper.deleteWorkPermit(permit.id!);
                    Navigator.pop(context); // 삭제 후 목록으로 복귀
                  }
                },
                child: const Text('삭제'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
