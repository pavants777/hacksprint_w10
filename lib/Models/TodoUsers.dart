class ToDoUsers {
  String uid;
  String hours;
  String minutes;
  String seconds;
  String file;
  bool isCompleted;

  ToDoUsers(
      {required this.uid,
      required this.hours,
      required this.seconds,
      required this.file,
      required this.minutes,
      required this.isCompleted});

  factory ToDoUsers.fromJson(Map<String, dynamic> json) {
    return ToDoUsers(
        uid: json['uid'],
        hours: json['hours'],
        seconds: json['seconds'],
        minutes: json['minutes'],
        file: json['file'],
        isCompleted: json['isCompleted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'file': file,
      'isCompleted': isCompleted,
    };
  }
}
