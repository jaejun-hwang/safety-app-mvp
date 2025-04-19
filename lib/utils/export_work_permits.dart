import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/work_permit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart'; // 엑셀 패키지 import
import '../helpers/firebase_service.dart'; // ✅ Firebase 서비스 임포트
import 'package:flutter/material.dart'; // 스낵바 사용을 위해 import

Future<String?> exportPermitsToExcel(BuildContext context, List<WorkPermit> permits) async {
  if (Platform.isAndroid || Platform.isIOS) {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ 저장 권한이 필요합니다.')),
          );
        }
        return null;
      }
    }

    var excel = Excel.createExcel();
    Sheet sheet = excel.sheets['Sheet1']!; // 기본 시트 선택

    // 헤더 행 추가
    sheet.appendRow([
      '공사명',
      '위치',
      '작업내용',
      '작업일시',
      '책임자',
      '작업자 수',
      '안전조치 확인',
      '특이사항',
    ]);

    // 데이터 행 추가
    for (var permit in permits) {
      sheet.appendRow([
        permit.constructionName,
        permit.location,
        permit.content,
        permit.date,
        permit.supervisor,
        permit.workerCount,
        permit.safetyChecked ? '예' : '아니오',
        permit.notes,
      ]);
    }

    try {
      Directory? directory;
      String fileName = 'work_permits_${DateTime.now().toIso8601String().replaceAll(':', '-')}.xlsx';
      List<int>? fileBytes = excel.save(); // 엑셀 파일 데이터를 byte 형태로 저장

      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null && fileBytes != null) {
        File file = File('${directory.path}/$fileName');
        await file.writeAsBytes(fileBytes); // byte 데이터를 파일에 씀

        // ✅ 엑셀 저장 성공 후 Firebase에 데이터 저장 (비동기 처리)
        int uploadedCount = 0;
        for (var permit in permits) {
          try {
            await FirebaseService.uploadWorkPermit(permit);
            uploadedCount++;
          } catch (e) {
            print('🔥 Firebase 업로드 실패 (ID: ${permit.id}): $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('⚠️ 일부 데이터의 Firebase 백업에 실패했습니다.')),
              );
            }
          }
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ 엑셀 저장 완료! (Firebase 백업: $uploadedCount/${permits.length})')),
          );
        }

        return file.path;
      } else {
        return null;
      }
    } catch (e) {
      print('🔥 엑셀 저장 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ 엑셀 저장에 실패했습니다.')),
        );
      }
      return null;
    }
  }