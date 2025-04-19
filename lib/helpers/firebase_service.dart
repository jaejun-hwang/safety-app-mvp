import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/work_permit.dart';

class FirebaseService {
  static Future<void> uploadWorkPermit(WorkPermit permit) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('work_permits').doc();

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

      print('✅ Firebase 업로드 완료');
    } catch (e) {
      print('❌ Firebase 업로드 실패: $e');
    }
  }
}
