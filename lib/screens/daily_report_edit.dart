import 'package:flutter/material.dart';
import '../models/daily_report.dart';
import '../helpers/db_helper_daily.dart';

class DailyReportEditScreen extends StatefulWidget {
  final DailyReport report;

  const DailyReportEditScreen({super.key, required this.report});

  @override
  State<DailyReportEditScreen> createState() => _DailyReportEditScreenState();
}

class _DailyReportEditScreenState extends State<DailyReportEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _siteNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _workerCountController;
  late TextEditingController _weatherController;
  late TextEditingController _issuesController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.parse(widget.report.date);
    _siteNameController = TextEditingController(text: widget.report.siteName);
    _descriptionController = TextEditingController(text: widget.report.workDescription);
    _workerCountController = TextEditingController(text: widget.report.workerCount.toString());
    _weatherController = TextEditingController(text: widget.report.weather);
    _issuesController = TextEditingController(text: widget.report.issues);
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _descriptionController.dispose();
    _workerCountController.dispose();
    _weatherController.dispose();
    _issuesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ❌ AppBar 제거
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '일일작업일보 수정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
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
                    final updatedReport = DailyReport(
                      id: widget.report.id,
                      date: _selectedDate.toIso8601String(),
                      siteName: _siteNameController.text,
                      workDescription: _descriptionController.text,
                      workerCount: int.tryParse(_workerCountController.text) ?? 0,
                      weather: _weatherController.text,
                      issues: _issuesController.text,
                    );

                    await DailyDBHelper.updateReport(updatedReport);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ 수정 완료')),
                      );
                      Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text('수정 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
