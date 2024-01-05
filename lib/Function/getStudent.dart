import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/QuestionPaperModel.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Utills/getXSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentFunction {
  static Stream<List<UserModels>> getStudent(BuildContext context) async* {
    var _user = Provider.of<UserProvider>(context, listen: false);

    try {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('collegeName', isEqualTo: _user.user?.collegeName)
          .snapshots()
          .map((event) {
        return event.docs.map((e) {
          return UserModels.fromJson(e.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error While Fetching Data: $e');
    }
  }
}
