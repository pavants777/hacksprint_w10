import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';



class FirebaseFunction {
  static Future<UserModels?> getCurrentUser(String? users) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('uid', isEqualTo: users)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return UserModels.fromJson(snapshot.docs.first.data());
    } else {
      return null;
    }
  }

  static Stream<List<GroupModels>> getGroups() async* {
    yield* FirebaseFirestore.instance
        .collection('groups')
        .orderBy('lasttimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => GroupModels.fromJson(doc.data()))
          .toList();
    });
  }

  static Future<List<String>> getAllTags(BuildContext context) async {
    List<String> allTags = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      for (var doc in querySnapshot.docs) {
        GroupModels groupModels = GroupModels.fromJson(doc.data());

        allTags.addAll(groupModels.tags);
      }
      return allTags;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    return allTags;
  }

  static Future<List<GroupModels>> getSearchGroup(
      BuildContext context, String data) async {
    List<GroupModels> res = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      for (var doc in snapshot.docs) {
        GroupModels groupModels = GroupModels.fromJson(doc.data());

        res.addAll(groupModels.tags
            .where((tag) => tag.toLowerCase().contains(data.toLowerCase()))
            .map((e) => groupModels));
      }

      return res;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error In Getting Groups",
        e.message!,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 10),
      );
    }
    return [];
  }

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
}
