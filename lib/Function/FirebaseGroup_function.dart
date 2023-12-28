import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Models/MessageModels.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FirebaseGroupFunction {
  // Create new Group

  static Future<void> createGroup(String groupName, List<String> usersIds,
      String profileUrl, List<String> tagsList, BuildContext context) async {
    try {
      CollectionReference groups =
          FirebaseFirestore.instance.collection('groups');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String groupId = groups.doc().id;
      final Timestamp timestamp = Timestamp.now();

      Map<String, dynamic> groupData = {
        'groupId': groupId,
        'groupName': groupName,
        'profileUrl': profileUrl,
        'lastMessage': "No Messages",
        'users': usersIds,
        'tags': tagsList,
        'lasttimestamp': timestamp,
        'isAdmin': uid,
      };
      await groups.doc(groupId).set(groupData);
      print('Group created successfully!');
      Navigator.pushReplacementNamed(context, Routes.homePage);
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  // getGroup By is Id

  static Future<GroupModels> getGroup(String groupId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('groups')
        .doc(groupId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();

      if (data != null) {
        dynamic usersData = data['users'];
        dynamic tagsData = data['tags'];

        List<String> usersList;
        List<String> tagsList;

        if (usersData is List) {
          usersList = List<String>.from(usersData);
        } else if (usersData is String) {
          usersList = (json.decode(usersData) as List<dynamic>).cast<String>();
        } else {
          usersList = [];
        }

        if (tagsData is List) {
          tagsList = List<String>.from(tagsData);
        } else if (tagsData is String) {
          tagsList = (json.decode(tagsData) as List<dynamic>).cast<String>();
        } else {
          throw Exception("Unexpected type for 'Tags' field");
        }

        return GroupModels(
          groupId: data['groupId'] ?? '',
          groupName: data['groupName'] ?? '',
          profileUrl: data['profileUrl'],
          lastMessage: data['lastMessage'],
          users: usersList,
          tags: tagsList,
          lasttimestamp: data['lasttimestamp'] != null
              ? (data['lasttimestamp'] as Timestamp).toDate()
              : null,
          isAdmin: data['isAdmin'] ?? '',
        );
      } else {
        throw Exception("Data is null for group with id $groupId");
      }
    } else {
      throw Exception("Group with id $groupId does not exist");
    }
  }

  // get Group from user groups data

  static Stream<List<GroupModels>> getGroupDetails(
      List<String> groupIds) async* {
    List<GroupModels> groupDetails = [];

    for (String groupId in groupIds) {
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();
      if (groupSnapshot.exists) {
        Map<String, dynamic> groupData =
            groupSnapshot.data() as Map<String, dynamic>;
        GroupModels group = GroupModels.fromJson(groupData);
        groupDetails.add(group);
      }
    }
    yield groupDetails;
  }

  // send message

  static Future<void> sendMessagetoGroup(String groupId, message,
      {isFile = false}) async {
    String senderId = await FirebaseAuth.instance.currentUser!.uid;

    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        message: message,
        senderId: senderId,
        timestamp: timestamp,
        isFile: isFile);

    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'lasttimestamp': timestamp,
      'lastMessage': message,
    });

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(newMessage.toJson());
  }

  // get message

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessageFromGroup(
      String groupId) async* {
    yield* FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // add Member to Group

  static Future<void> addMemberstoGroup(String uid, groupId) async {
    final groupRef =
        FirebaseFirestore.instance.collection('groups').doc(groupId);
    final groupSnapshot = await groupRef.get();
    List<String> currentMembers =
        List<String>.from(groupSnapshot.data()?['users'] ?? []);
    currentMembers.add(uid);
    Set<String> members = Set<String>();
    members = currentMembers.map((e) => e).toSet();
    currentMembers = members.map((e) => e).toList();
    await groupRef.update({'users': currentMembers});
  }
}
