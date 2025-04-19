import 'package:flutter/material.dart';
import '../models/work_permit.dart';
import '../helpers/db_helper.dart';
import '../helpers/firebase_service.dart'; // ✅ Firebase 서비스 임포트

class WorkPermitEditScreen extends StatefulWidget {
  final WorkPermit permit;

  const WorkPermitEditScreen({super.key, required this.permit});

  @override
  State<WorkPermitEditScreen> createState() => _WorkPermitEditScreenState();
}

class _WorkPermitEditScreenState extends State<WorkPermitEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _constructionNameController;
  late TextEditingController _locationController;
  late TextEditingController _contentController;
  late TextEditingController _supervisorController;
  late TextEditingController _workerCountController;
  late TextEditingController _notesController;

  late DateTime _selectedDate;
  late bool _safetyChecked;

  @override
  void initState() {
    super.initState();
    final permit = widget.permit;

    _constructionNameController = TextEditingController(text: permit.constructionName);
    _locationController = TextEditingController(text: permit.location);
    _contentController = TextEditingController(text: permit.content);
    _supervisorController = TextEditingController(text: permit.supervisor);
    _workerCountController = TextEditingController(text: permit.workerCount?.toString() ?? '');
    _notesController = TextEditingController(text: permit.notes ?? '');

    _selectedDate = DateTime.parse(permit.date);
    _safetyChecked = permit.safetyChecked;
  }

  @override
  void dispose() {
    _constructionNameController.dispose();
    _locationController.dispose();
    _contentController.dispose();
    _supervisorController.dispose();
    _workerCountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final updated = WorkPermit(
        id: widget.permit.id,
        constructionName: _constructionNameController.text,
        location: _locationController.text,
        content: _contentController.text,
        date: _selectedDate.toIso8601String(),
        supervisor: _supervisorController.text,
        workerCount: int.tryParse(_workerCountController.text) ?? 0,
        safetyChecked: _safetyChecked,
        notes: _notesController.text,
      );

      await DBHelper.updateWorkPermit(updated); // 로컬 데이터베이스 업데이트
      await FirebaseService.updateWorkPermit(updated); // Firebase 업데이트

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ 수정 완료 및 Firebase 동기화 완료!')),
        );
        Navigator.of(context).pop(true); // 변경 완료 후 뒤로 가기
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('작업허가서 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _constructionNameController,
                decoration: const InputDecoration(labelText: '공사명'),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: '작업위치'),
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '작업내용'),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text("작업일시: ${_selectedDate.toLocal()}".split('.')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              TextFormField(
                controller: _supervisorController,
                decoration: const InputDecoration(labelText: '책임자 이름'),
              ),
              TextFormField(
                controller: _workerCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '작업자 수'),
              ),
              CheckboxListTile(
                title: const Text("안전조치 사항 확인"),
                value: _safetyChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _safetyChecked = value ?? false;
                  });
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: '특이사항'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}