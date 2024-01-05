import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/QuestionPaperModel.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Utills/getXSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionFunction {
  static Future<void> sendQuestionPaper(String name, fileUrl, year, sem,
      subjectName, bool isSem, BuildContext context) async {
    try {
      var _user = Provider.of<UserProvider>(context, listen: false);
      DocumentReference ref = FirebaseFirestore.instance
          .collection('Question')
          .doc('${_user.user?.collegeName}')
          .collection('${_user.user?.branch}')
          .doc();

      String refId = ref.id;
      QuestionModel data = QuestionModel(
          refId: refId,
          name: name,
          fileUrl: fileUrl,
          year: year,
          sem: sem,
          collegeName: _user.user!.collegeName,
          subjects: subjectName,
          isSem: isSem);

      await ref.set(data.toMap());
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      GetXSnackbar("Error While Sending Question Paper", e.message);
    }
  }

  static Stream<List<QuestionModel>> getQuestionPage(
      BuildContext context) async* {
    var _user = Provider.of<UserProvider>(context, listen: false);

    yield* FirebaseFirestore.instance
        .collection('Question')
        .doc(_user.user?.collegeName ?? "Unknown")
        .collection(_user.user!.branch)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => QuestionModel.fromJson(e.data())).toList();
    });
  }
}


//  yield* FirebaseFirestore.instance
//         .collection('Data')
//         .doc(uid)
//         .collection('works')
//         .snapshots()
//         .map((event) {
//       return event.docs.map((e) => Models.fromJson(e.data())).toList();
//     });