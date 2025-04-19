import 'package:flutter/material.dart';
import '../models/work_permit.dart';
import '../helpers/db_helper.dart';
import '../helpers/firebase_service.dart'; // ✅ Firebase 업로드 기능 추가
import 'package:safety_manager_app/screens/work_permit_list.dart';

class WorkPermitForm extends StatefulWidget {
  const WorkPermitForm({super.key});

  @override
  State<WorkPermitForm> createState() => _WorkPermitFormState();
}

class _WorkPermitFormState extends State<WorkPermitForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _constructionNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  final TextEditingController _workerCountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _safetyChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('작업허가서 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final permit = WorkPermit(
                      constructionName: _constructionNameController.text,
                      location: _locationController.text,
                      content: _contentController.text,
                      date: _selectedDate.toIso8601String(),
                      supervisor: _supervisorController.text,
                      workerCount: int.tryParse(_workerCountController.text) ?? 0,
                      safetyChecked: _safetyChecked,
                      notes: _notesController.text,
                    );

                    await DBHelper.insertWorkPermit(permit); // ✅ 로컬 저장
                    await FirebaseService.uploadWorkPermit(permit); // ✅ Firebase 업로드

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ 저장 및 백업 완료!')),
                      );
                    }

                    // 입력 초기화
                    _formKey.currentState!.reset();
                    _constructionNameController.clear();
                    _locationController.clear();
                    _contentController.clear();
                    _supervisorController.clear();
                    _workerCountController.clear();
                    _notesController.clear();

                    setState(() {
                      _selectedDate = DateTime.now();
                      _safetyChecked = false;
                    });
                  }
                },
                child: const Text('저장'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WorkPermitListScreen(),
                    ),
                  );
                },
                child: const Text('저장된 목록 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
