import 'package:cmc/Models/TodoUsers.dart';

class ToDoModels {
  String refId;
  String groupName;
  String groupId;
  String title;
  String hours;
  String minutes;
  List<String> completed;
  List<String> tags;
  List<ToDoUsers> users;

  ToDoModels({
    required this.refId,
    required this.groupId,
    required this.groupName,
    required this.title,
    required this.hours,
    required this.minutes,
    required this.completed,
    required this.tags,
    required this.users,
  });

  factory ToDoModels.fromJson(Map<String, dynamic> json) {
    return ToDoModels(
      refId: json['refId'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      title: json['title'],
      hours: json['hours'],
      minutes: json['minutes'],
      completed: (json['completed'] as List<dynamic>?)
              ?.map((members) => members.toString())
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => ToDoUsers.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'groupId': groupId,
      'groupName': groupName,
      'title': title,
      'hours': hours,
      'minutes': minutes,
      'completed': completed,
      'tags': tags,
      'users': users.map((user) => user.toMap()).toList(),
    };
  }
}
