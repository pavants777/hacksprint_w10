import 'package:cmc/Function/question.dart';
import 'package:cmc/Models/QuestionPaperModel.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Groups/QuestionPager/CreateQuestionpage.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
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
                          return Text('${question[index].name}');
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
}
