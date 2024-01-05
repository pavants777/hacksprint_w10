import 'package:cmc/Function/getStudent.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${_user.user?.collegeName} : College Student',
          softWrap: true,
          style: TextStyle(color: Colors.yellow),
        ),
      ),
      body: Center(
        child: StreamBuilder<List<UserModels>>(
            stream: StudentFunction.getStudent(context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error While Fetching Students'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Indicator();
              }
              List<UserModels>? student = snapshot.data;

              if (student == null || student?.length == 0) {
                return Center(
                  child: Text("No User Founded In Your College"),
                );
              }
              return ListView.builder(
                  itemCount: student.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(student[index]);
                  });
            }),
      ),
    );
  }

  Widget _buildUserCard(UserModels user) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 10),
            Text(
              '${user.userName}',
              style: TextStyle(fontSize: 20),
            ),
            user.isEmail
                ? Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                : Container(),
            SizedBox(height: 10),
          ]),
          Text('${user.email}')
        ],
      ),
    );
  }
}
