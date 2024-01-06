import 'dart:async';
import 'dart:io';

import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Screens/ToDo/CompletedPage.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadTask extends StatefulWidget {
  ToDoModels todo;
  UploadTask({super.key, required this.todo});

  @override
  State<UploadTask> createState() => _UploadTaskState();
}

class _UploadTaskState extends State<UploadTask> {
  PlatformFile? pickedFile;

  Future<void> uploadFile(BuildContext context) async {
    if (pickedFile == null) {
      return;
    }

    final path = 'files/tasks/${pickedFile!.name}';
    final file = File(pickedFile!.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      await ref.putFile(file);
      final downloadURL = await ref.getDownloadURL();
      print(downloadURL);
      FirebaseToDo.changeTime(
          00, 00, 00, FirebaseAuth.instance.currentUser!.uid, widget.todo,
          file: pickedFile!.name, isCompleted: true);
    } catch (e) {
      print('Error during file upload: $e');
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Upload Your Completed Task',
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: Row(
              children: [
                Expanded(
                  child: Text('${pickedFile?.name ?? ""}'),
                ),
                TextButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () async {
              uploadFile(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Indicator(),
                ),
              );
              await Future.delayed(
                const Duration(seconds: 3),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedPage(todo: widget.todo),
                ),
              );
            },
            child: const Text(
              'Completed',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
