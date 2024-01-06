import 'package:cmc/Function/getStudent.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Groups/Students/ProfilView.dart';
import 'package:cmc/Utills/Constant.dart';
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
    return Padding(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileView(
                        user: user,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.yellow,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(user.profilePhoto ?? Constant.image),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 70,
                ),
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
        ),
      ),
    );
  }
}
