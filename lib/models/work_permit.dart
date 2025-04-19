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
}
