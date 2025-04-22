import 'package:flutter/material.dart';
import '../models/daily_report.dart';
import '../helpers/db_helper_daily.dart';
import '../helpers/firebase_service.dart'; // ✅ FirebaseService 클래스 import


class DailyReportForm extends StatefulWidget {
  const DailyReportForm({super.key});

  @override
  State<DailyReportForm> createState() => _DailyReportFormState();
}

class _DailyReportFormState extends State<DailyReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _siteNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _workerCountController = TextEditingController();
  final _weatherController = TextEditingController();
  final _issuesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일일작업일보 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text("날짜: ${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
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
                controller: _siteNameController,
                decoration: const InputDecoration(labelText: '현장명'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: '작업내용'),
              ),
              TextFormField(
                controller: _workerCountController,
                decoration: const InputDecoration(labelText: '작업자 수'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _weatherController,
                decoration: const InputDecoration(labelText: '날씨'),
              ),
              TextFormField(
                controller: _issuesController,
                decoration: const InputDecoration(labelText: '특이사항'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final report = DailyReport(
                      date: _selectedDate.toIso8601String(),
                      siteName: _siteNameController.text,
                      workDescription: _descriptionController.text,
                      workerCount: int.tryParse(_workerCountController.text) ?? 0,
                      weather: _weatherController.text,
                      issues: _issuesController.text,
                    );

                    await DailyDBHelper.insertReport(report);
                    await FirebaseService.uploadDailyReport(report);  // ✅ Firebase에 백업


                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ 일일작업일보 저장 완료')),
                      );
                    }

                    _formKey.currentState!.reset();
                    setState(() {
                      _selectedDate = DateTime.now();
                    });
                  }
                },
                child: const Text('저장'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/dailyReportList');
                },
                child: const Text('📋 저장된 일보 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
