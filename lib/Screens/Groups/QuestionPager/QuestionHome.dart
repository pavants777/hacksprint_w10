import 'package:cmc/Function/question.dart';
import 'package:cmc/Models/QuestionPaperModel.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Groups/QuestionPager/CreateQuestionpage.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/date_symbols.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Question Paper ${_user.user?.collegeName}',
          softWrap: true,
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<List<QuestionModel>>(
                stream: QuestionFunction.getQuestionPage(context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error while Fetching Question Paper'),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Indicator();
                  }

                  List<QuestionModel>? question = snapshot.data;
                  if (question?.length == 0 || question == null) {
                    return Center(
                      child: Text('No Question Paper From Your College'),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: question!.length,
                        itemBuilder: (context, index) {
                          return _buildCard(question[index]);
                        }),
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendQuestionPaper(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(QuestionModel question) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          _downloadFile(question.fileUrl);
        },
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 251, 235, 89),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
              ),
              SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '${question.name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('${question.year}   :   ${question.sem}th Sem',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
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
