import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/work_permit.dart';
import '../models/daily_report.dart'; // ✅ 일일작업일보 모델 추가

class FirebaseService {
  /// 작업허가서 신규 업로드
  static Future<void> uploadWorkPermit(WorkPermit permit) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('work_permits')
          .doc(permit.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString());

      await docRef.set({
        'constructionName': permit.constructionName,
        'location': permit.location,
        'content': permit.content,
        'date': permit.date,
        'supervisor': permit.supervisor,
        'workerCount': permit.workerCount,
        'safetyChecked': permit.safetyChecked,
        'notes': permit.notes,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ 작업허가서 Firebase 업로드 완료');
    } catch (e) {
      print('❌ 작업허가서 Firebase 업로드 실패: $e');
    }
  }

  /// 작업허가서 수정
  static Future<void> updateWorkPermit(WorkPermit permit) async {
    if (permit.id == null) {
      throw ArgumentError('작업허가서 ID가 필요합니다');
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection('work_permits')
          .doc(permit.id.toString());

      await docRef.update({
        'constructionName': permit.constructionName,
        'location': permit.location,
        'content': permit.content,
        'date': permit.date,
        'supervisor': permit.supervisor,
        'workerCount': permit.workerCount,
        'safetyChecked': permit.safetyChecked,
        'notes': permit.notes,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ 작업허가서 Firebase 수정 완료');
    } catch (e) {
      print('❌ 작업허가서 Firebase 수정 실패: $e');
    }
  }

  /// ✅ 일일작업일보 신규 업로드
  static Future<void> uploadDailyReport(DailyReport report) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('daily_reports')
          .doc(report.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString());

      await docRef.set({
        'date': report.date,
        'siteName': report.siteName,
        'workDescription': report.workDescription,
        'workerCount': report.workerCount,
        'weather': report.weather,
        'issues': report.issues,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('✅ 일일작업일보 Firebase 업로드 완료');
    } catch (e) {
      print('❌ 일일작업일보 Firebase 업로드 실패: $e');
    }
  }
}
