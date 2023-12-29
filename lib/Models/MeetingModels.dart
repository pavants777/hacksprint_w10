class MeetingModels {
  String meetingId;
  String meetingName;
  List<String> joinedMembers;
  List<String> tags;
  List<String> members;

  MeetingModels(
      {required this.meetingId,
      required this.meetingName,
      required this.joinedMembers,
      required this.tags,
      required this.members});

  factory MeetingModels.fromJson(Map<String, dynamic> json) {
    return MeetingModels(
      meetingId: json['meetingId'] ?? '',
      meetingName: json['meetingName'] ?? '',
      joinedMembers: (json['joinedMembers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tags) => tags.toString())
              .toList() ??
          [],
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
