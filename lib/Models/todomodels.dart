class ToDoModels {
  String groupName;
  String groupId;
  String title;
  String hours;
  String minutes;
  List<String> completed;
  List<String> tags;
  List<String> members;

  ToDoModels({
    required this.groupId,
    required this.groupName,
    required this.title,
    required this.hours,
    required this.minutes,
    required this.completed,
    required this.tags,
    required this.members,
  });

  factory ToDoModels.fromJson(Map<String, dynamic> json) {
    return ToDoModels(
        groupId: json['groupId'],
        groupName: json['groupName'],
        title: json['title'],
        hours: json['hours'],
        minutes: json['minutes'],
        completed: (json['completed'] as List<dynamic>?)
                ?.map((members) => members.toString())
                .toList() ??
            [],
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        members: (json['members'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            []);
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'title': title,
      'hours': hours,
      'minutes': minutes,
      'completed': completed,
      'tags': tags,
      'members': members,
    };
  }
}
