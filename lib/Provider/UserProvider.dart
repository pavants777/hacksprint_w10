import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModels? user;
  bool isUser = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  UserProvider() {
    initialize();
  }

  void initialize() async {
    print('function initialize');
    print(isUser);
    try {
      uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);

      user = await FirebaseFunction.getCurrentUser(uid);
      print(user);

      isUser = true;
      print('function gets up');
      print(isUser);

      notifyListeners();
    } catch (error) {
      print('Error during initialization: $error');
      // Handle the error as needed
    }
  }

  void emailVerfication() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'isEmail': true});

    user?.isEmail = true;
    notifyListeners();
  }

  void signOut() {
    isUser = false;
    user = null;
    print(isUser);
    print(user);
    notifyListeners();
  }
}
