class QuestionModel {
  String name;
  String fileUrl;
  String year;
  String sem;
  String collegeName;
  String subjects;
  bool isSem;
  String refId;

  QuestionModel(
      {required this.name,
      required this.fileUrl,
      required this.year,
      required this.sem,
      required this.collegeName,
      required this.subjects,
      required this.isSem,
      required this.refId});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        name: json['name'],
        fileUrl: json['fileUrl'],
        year: json['year'],
        sem: json['sem'],
        collegeName: json['collegeName'],
        subjects: json['subjects'],
        isSem: json['isSem'],
        refId: json['refId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'name': name,
      'fileUrl': fileUrl,
      'year': year,
      'sem': sem,
      'collegeName': collegeName,
      'subjects': subjects,
      'isSem': isSem,
    };
  }
}
