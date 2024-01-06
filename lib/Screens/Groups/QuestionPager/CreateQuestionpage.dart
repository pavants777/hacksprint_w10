import 'dart:io';

import 'package:cmc/Function/question.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SendQuestionPaper extends StatefulWidget {
  const SendQuestionPaper({super.key});

  @override
  State<SendQuestionPaper> createState() => _SendQuestionPaperState();
}

class _SendQuestionPaperState extends State<SendQuestionPaper> {
  TextEditingController _name = TextEditingController();
  TextEditingController _year = TextEditingController();
  TextEditingController _sem = TextEditingController();
  TextEditingController _subjectName = TextEditingController();
  bool isSem = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile(BuildContext context) async {
    final path = 'files/question/${pickedFile!.name}';
    final file = File(pickedFile!.path ?? '');

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() => {});

    final downloadURL = await snapshot.ref.getDownloadURL();
    print(downloadURL);
    setState(() {
      uploadTask = null;
    });

    QuestionFunction.sendQuestionPaper(_name.text, pickedFile!.name, _year.text,
        _sem.text, _subjectName.text, true, context);
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
      appBar: AppBar(
          title: Text(
        'Add Question Paper',
        style: TextStyle(color: Colors.yellow),
      )),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CompanyLogo(300, 300),
            SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    prefixIcon: const Icon(Icons.title),
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 300,
                child: TextField(
                  controller: _subjectName,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    prefixIcon: const Icon(FontAwesomeIcons.userNinja),
                    hintText: 'Subject Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _year,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(FontAwesomeIcons.newspaper),
                        hintText: 'Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _sem,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: const Icon(FontAwesomeIcons.newspaper),
                        hintText: 'Sem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )),
              ],
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
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                if (pickedFile?.name != null) {
                  uploadFile(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: const Text(
                  'Send',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
