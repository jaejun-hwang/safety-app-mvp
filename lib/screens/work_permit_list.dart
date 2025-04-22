import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/work_permit.dart';
import 'work_permit_detail.dart';
import 'package:excel/excel.dart';
//import 'package:excel/cell.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import '../helpers/firebase_service.dart'; // ✅ Firebase 서비스 임포트

class WorkPermitListScreen extends StatefulWidget {
  const WorkPermitListScreen({super.key});

  @override
  State<WorkPermitListScreen> createState() => _WorkPermitListScreenState();
}

class _WorkPermitListScreenState extends State<WorkPermitListScreen> {
  List<WorkPermit> _allPermits = [];
  List<WorkPermit> _filteredPermits = [];
  List<WorkPermit> _selectedPermits = []; // 선택된 작업 허가서 목록
  TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPermits();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadPermits() async {
    final permits = await DBHelper.getWorkPermits();
    setState(() {
      _allPermits = permits;
      _applyFilters();
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final selectedDateString = _selectedDate?.toIso8601String().split('T').first;

    setState(() {
      _filteredPermits = _allPermits.where((permit) {
        final matchesText = permit.constructionName.toLowerCase().contains(query) ||
            permit.date.toLowerCase().contains(query);
        final matchesDate = _selectedDate == null || permit.date.contains(selectedDateString!);
        return matchesText && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _selectedDate = picked;
    } else {
      _selectedDate = null;
    }

    _applyFilters();
  }

  void _toggleSelect(WorkPermit permit, bool? value) {
    setState(() {
      if (value == true) {
        if (!_selectedPermits.contains(permit)) {
          _selectedPermits.add(permit);
        }
      } else {
        _selectedPermits.remove(permit);
      }
    });
  }

  Future<String?> _exportPermitsToCSV(List<WorkPermit> permits) async {
    // ... 기존 CSV 내보내기 로직 ...
  }

  Future<String?> _exportPermitsToExcel(List<WorkPermit> permits) async {
    // ... 기존 엑셀 내보내기 로직 ...
  }

  Future<void> _saveSelectedPermitsToFirebase() async {
    if (_selectedPermits.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ 저장할 항목을 선택해주세요.')),
        );
      }
      return;
    }

    int successCount = 0;
    for (var permit in _selectedPermits) {
      try {
        await FirebaseService.uploadWorkPermit(permit);
        successCount++;
      } catch (e) {
        print('🔥 Firebase 저장 실패 (ID: ${permit.id}): $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('⚠️ 일부 항목의 Firebase 저장에 실패했습니다.')),
          );
        }
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ 선택된 항목 ($successCount/${_selectedPermits.length})을 Firebase에 저장했습니다.')),
      );
    }

    // 저장 후 선택 목록 초기화 (선택 사항)
    setState(() {
      _selectedPermits.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작업허가서 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: '선택 항목 CSV로 내보내기',
            onPressed: _selectedPermits.isNotEmpty ? () async {
              final path = await _exportPermitsToCSV(_selectedPermits);
              if (path != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('CSV 저장 완료: $path')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('저장 권한이 필요합니다.')),
                );
              }
            } : null,
          ),
          IconButton(
            icon: const Icon(Icons.insert_drive_file),
            tooltip: '선택 항목 Excel로 내보내기',
            onPressed: _selectedPermits.isNotEmpty ? () async {
              final path = await _exportPermitsToExcel(_selectedPermits);
              if (path != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Excel 저장 완료: $path')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('저장 권한이 필요합니다.')),
                );
              }
            } : null,
          ),
          IconButton( // ✅ Firebase 저장 버튼 추가
            icon: const Icon(Icons.cloud_upload),
            tooltip: '선택 항목 Firebase에 저장',
            onPressed: _selectedPermits.isNotEmpty
                ? () async {
              await _saveSelectedPermitsToFirebase();
            }
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '공사명 또는 날짜 검색',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_selectedDate == null
                          ? '날짜 선택'
                          : '선택됨: ${_selectedDate!.toIso8601String().split('T').first}'),
                    ),
                    const SizedBox(width: 10),
                    if (_selectedDate != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                            _applyFilters();
                          });
                        },
                        child: const Text('날짜 초기화'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPermits.isEmpty
                ? const Center(child: Text('검색 결과가 없습니다.'))
                : ListView.builder(
              itemCount: _filteredPermits.length,
              itemBuilder: (context, index) {
                final permit = _filteredPermits[index];
                return CheckboxListTile( // CheckboxListTile 사용
                  title: Text(permit.constructionName),
                  subtitle: Text('위치: ${permit.location}\n일시: ${permit.date}'),
                  isThreeLine: true,
                  value: _selectedPermits.contains(permit),
                  onChanged: (bool? value) {
                    _toggleSelect(permit, value);
                  },
                  secondary: IconButton( // 상세 보기 버튼 추가 (선택과 별개로 동작)
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WorkPermitDetailScreen(permit: permit),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}