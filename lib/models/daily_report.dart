class DailyReport {
  final int? id;
  final String date;
  final String siteName;
  final String workDescription;
  final int workerCount;
  final String weather;
  final String issues;

  DailyReport({
    this.id,
    required this.date,
    required this.siteName,
    required this.workDescription,
    required this.workerCount,
    required this.weather,
    required this.issues,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'siteName': siteName,
      'workDescription': workDescription,
      'workerCount': workerCount,
      'weather': weather,
      'issues': issues,
    };
  }

  factory DailyReport.fromMap(Map<String, dynamic> map) {
    return DailyReport(
      id: map['id'],
      date: map['date'],
      siteName: map['siteName'],
      workDescription: map['workDescription'],
      workerCount: map['workerCount'],
      weather: map['weather'],
      issues: map['issues'],
    );
  }
}
