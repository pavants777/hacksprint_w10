import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeetingHome extends StatefulWidget {
  const MeetingHome({super.key});

  @override
  State<MeetingHome> createState() => _MeetingHomeState();
}

class _MeetingHomeState extends State<MeetingHome> {
  UserModels? user;
  String? uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    UserModels? userref = await FirebaseFunction.getCurrentUser(uid);
    setState(() {
      user = userref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Meetings', context) as PreferredSizeWidget?,
    );
  }
}
