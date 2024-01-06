import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Function/firebase_todo.dart';
import 'package:cmc/Models/TodoUsers.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Models/todomodels.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LeaderBoard extends StatefulWidget {
  ToDoModels todo;
  LeaderBoard({super.key, required this.todo});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LeaderBoard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ToDoUsers>>(
        stream: FirebaseToDo.getCompletedUser(widget.todo),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error while Fetching Data"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Indicator();
          }
          List<ToDoUsers>? user = snapshot.data;
          print(snapshot.data);
          if (user!.length == 0) {
            return Center(
              child: Text('No One Is Completed'),
            );
          }
          return ListView.builder(
            itemCount: user.length,
            itemBuilder: (context, index) {
              return _buildCard(user[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(ToDoUsers usertodo) {
    return FutureBuilder<UserModels?>(
      future: FirebaseFunction.getCurrentUser(usertodo.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return Container();
          }
          UserModels user = snapshot.data!;
          return _buildUI(user, usertodo);
        } else {
          return Indicator();
        }
      },
    );
  }

  Widget _buildUI(UserModels user, ToDoUsers userToDo) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          _downloadFile(userToDo.file);
        },
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(width: 0.5, color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${user.userName}',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  user.isEmail
                      ? Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : Container(),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    '${user.collegeName}',
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${user.email}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadFile(String fileName) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('files/tasks/$fileName');
      String downloadUrl = await ref.getDownloadURL();
      print(downloadUrl);

      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/$fileName';

      await Dio().download(downloadUrl, path);

      if (downloadUrl.contains('.mp4')) {
        OpenFile.open(path);
        await GallerySaver.saveVideo(path, toDcim: true);
      } else if (downloadUrl.contains('.jpg') ||
          downloadUrl.contains('.jpeg')) {
        OpenFile.open(path);
        await GallerySaver.saveImage(path, toDcim: true);
      } else if (downloadUrl.contains('.pdf')) {
        await OpenFile.open(path);
      }
    } catch (error) {
      print('Error during file download: $error');
    }
  }
}
