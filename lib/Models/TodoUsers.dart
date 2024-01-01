class ToDoUsers {
  String uid;
  String hours;
  String minutes;
  String seconds;
  bool isCompleted;

  ToDoUsers(
      {required this.uid,
      required this.hours,
      required this.seconds,
      required this.minutes,
      required this.isCompleted});

  factory ToDoUsers.fromJson(Map<String, dynamic> json) {
    return ToDoUsers(
        uid: json['uid'],
        hours: json['hours'],
        seconds: json['seconds'],
        minutes: json['minutes'],
        isCompleted: json['isCompleted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
      'isCompleted': isCompleted,
    };
  }
}
