import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoHome extends StatefulWidget {
  ToDoHome({super.key});

  @override
  State<ToDoHome> createState() => _ToDoHomeState();
}

class _ToDoHomeState extends State<ToDoHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        'ToDo',
        context,
      ) as PreferredSizeWidget?,
    );
  }
}
