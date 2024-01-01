import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModels {
  final String groupId;
  final String groupName;
  final String profileUrl;
  final String lastMessage;
  final List<String> users;
  final List<String> tags;
  final DateTime? lasttimestamp;
  final String? isAdmin;

  GroupModels({
    required this.groupId,
    required this.groupName,
    required this.profileUrl,
    required this.lastMessage,
    required this.users,
    required this.tags,
    required this.lasttimestamp,
    required this.isAdmin,
  });

  factory GroupModels.fromJson(Map<String, dynamic> json) {
    return GroupModels(
      groupId: json['groupId'] ?? '',
      groupName: json['groupName'] ?? '',
      profileUrl: json['profileUrl'],
      lastMessage: json['lastMessage'],
      users: (json['users'] as List<dynamic>?)
              ?.map((user) => user.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tags) => tags.toString())
              .toList() ??
          [],
      lasttimestamp: json['lasttimestamp'] != null
          ? (json['lasttimestamp'] as Timestamp).toDate()
          : null,
      isAdmin: json['isAdmin'] ?? '',
    );
  }
}
