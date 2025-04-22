class WorkPermit {
  final int? id;
  final String constructionName;
  final String location;
  final String content;
  final String date;
  final String supervisor;
  final int workerCount;
  final bool safetyChecked;
  final String notes;

  WorkPermit({
    this.id,
    required this.constructionName,
    required this.location,
    required this.content,
    required this.date,
    required this.supervisor,
    required this.workerCount,
    required this.safetyChecked,
    required this.notes,
  });

  /// ✅ SQLite 저장용 (int로 변환됨)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'constructionName': constructionName,
      'location': location,
      'content': content,
      'date': date,
      'supervisor': supervisor,
      'workerCount': workerCount,
      'safetyChecked': safetyChecked ? 1 : 0,
      'notes': notes,
    };
  }

  factory WorkPermit.fromMap(Map<String, dynamic> map) {
    return WorkPermit(
      id: map['id'],
      constructionName: map['constructionName'],
      location: map['location'],
      content: map['content'],
      date: map['date'],
      supervisor: map['supervisor'],
      workerCount: map['workerCount'],
      safetyChecked: map['safetyChecked'] == 1,
      notes: map['notes'],
    );
  }

  /// ✅ Firebase Firestore 저장용 (bool은 그대로 true/false)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'constructionName': constructionName,
      'location': location,
      'content': content,
      'date': date,
      'supervisor': supervisor,
      'workerCount': workerCount,
      'safetyChecked': safetyChecked,
      'notes': notes,
    };
  }

  /// ✅ Firebase에서 읽어올 때 사용
  factory WorkPermit.fromJson(Map<String, dynamic> json) {
    return WorkPermit(
      id: json['id'],
      constructionName: json['constructionName'],
      location: json['location'],
      content: json['content'],
      date: json['date'],
      supervisor: json['supervisor'],
      workerCount: json['workerCount'],
      safetyChecked: json['safetyChecked'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}
