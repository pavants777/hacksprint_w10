import 'dart:math';
import 'package:cmc/Function/meeting_function.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Meeting/LiveMeeting.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  GroupModels? group;
  CreateRoom({super.key, required this.group});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  TextEditingController _roomName = TextEditingController();
  TextEditingController _tagsEditingController = TextEditingController();
  List<String> tags = [];
  int roomId = 9999999;

  @override
  void initState() {
    // TODO: implement initState
    roomId = Random().nextInt(1000000) + 100000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Audio Room'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 30,
              ),
              CompanyLogo(200, 200),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: _roomName,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    prefixIcon: Icon(Icons.group),
                    hintText: 'RoomName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagsEditingController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Icon(Icons.tag),
                          hintText: 'Enter Tags To Add',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_tagsEditingController.text.isNotEmpty) {
                          setState(() {
                            tags.add(_tagsEditingController.text);
                            _tagsEditingController.clear();
                          });
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  createMeeting();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 100,
                  child: Text(
                    ' Create ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createMeeting() async {
    var _user = Provider.of<UserProvider>(context, listen: false);
    if (_roomName.text.isNotEmpty) {
      MeetingFunction.createMeeting(_roomName.text, roomId.toString(),
          [_user.uid], tags, widget.group?.users ?? []);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LivePage(
                    roomID: roomId.toString(),
                    isHost: true,
                    userName: _user.user?.userName ?? 'Unkown',
                    userUid: _user.uid,
                    profilePhoto: _user.user?.profilePhoto ?? Constant.image,
                  )));
    }
  }
}
