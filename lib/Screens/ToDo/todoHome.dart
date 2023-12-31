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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(
        'ToDo',
        context,
      ) as PreferredSizeWidget?,
      bottomSheet: Stack(
        children: [
          SizedBox(
              width: double.infinity,
              height: 50,
              child: LinearProgressIndicator(
                value: 0.5,
                color: Colors.green,
              )),
          Positioned(
              bottom: -5,
              left: screenWidth * 0.37,
              child: Text(
                '50.00%',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
