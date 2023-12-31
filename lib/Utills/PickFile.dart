import 'dart:io';
import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Function/FirebaseGroup_function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PickFile extends StatefulWidget {
  String groupId;
  PickFile({Key? key, required this.groupId}) : super(key: key);

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
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

    FirebaseGroupFunction.sendMessagetoGroup(widget.groupId, pickedFile!.name,
        isFile: true);
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  width: double.infinity,
                  height: 400,
                  child: pickedFile == null
                      ? Container(
                          width: double.infinity,
                          height: 500,
                        )
                      : Stack(
                          children: [
                            Image.file(
                              File(
                                pickedFile?.path ?? '',
                              ),
                              width: double.infinity,
                              height: 500,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 50,
                              child:
                                  Text('${pickedFile?.name ?? 'Unknown File'}'),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  selectFile();
                },
                child: Text('Select File'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  uploadFile();
                },
                child: Text('Upload File'),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<TaskSnapshot>(
                stream: uploadTask?.snapshotEvents,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data;
                    double progress = data!.bytesTransferred / data!.totalBytes;
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 30,
                            child: LinearProgressIndicator(
                              value: progress,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4,
                          left: screenWidth * 0.40,
                          child: Text(
                            '${(progress * 100).toStringAsFixed(2)} %',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              uploadTask == null
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back'))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
