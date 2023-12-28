import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/SplashScreens/UserInfoScreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseSplashFunction {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static login(String email, password, BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((_) {
      Provider.of<UserProvider>(context, listen: false).initialize();
      Navigator.pushReplacementNamed(context, Routes.homePage);
    }).catchError((e, stackTrace) {
      final snackBar = SnackBar(
        content: Text(e.message!),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  static createUser(String email, password, BuildContext context) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UserSetUP()));
    }).catchError((e) {
      final snackBar = SnackBar(
        content: Text(e.message!),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  static createUserInfo(
      String userName, url, collegeName, branch, isOnline, isEmail) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? email = await FirebaseAuth.instance.currentUser!.email;
    List<String> groups = [];

    Map<String, dynamic> data = {
      'uid': uid,
      'email': email,
      'userName': userName,
      'profilePhoto': url,
      'collegeName': collegeName,
      'branch': branch,
      'isOnline': isOnline,
      'isEmail': isEmail,
      'groups': groups,
    };
    await FirebaseFirestore.instance.collection('users').doc(uid).set(data);
  }
}
