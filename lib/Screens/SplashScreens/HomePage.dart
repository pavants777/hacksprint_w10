import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Groups/GroupHome.dart';
import 'package:cmc/Screens/Meeting/meetingHome.dart';
import 'package:cmc/Screens/Search/searchHome.dart';
import 'package:cmc/Screens/ToDo/Todo_home.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  late Widget page = const GroupHome();
  late String? uid;
  late UserModels? user;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    print(uid);
    getUser();
  }

  void getUser() async {
    UserModels? userref = await FirebaseFunction.getCurrentUser(uid);
    setState(() {
      user = userref;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, _) {
      return (!user.isUser)
          ? const Indicator()
          : Scaffold(
              body: page,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 10,
                selectedItemColor: Colors.yellow,
                unselectedItemColor: Colors.grey.shade400,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.group), label: 'Groups'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: 'Search'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.audio_file), label: 'Meeting'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.work), label: 'ToDo'),
                ],
                currentIndex: index,
                onTap: (int tappedIndex) {
                  setState(() {
                    index = tappedIndex;
                  });

                  switch (index) {
                    case 0:
                      setState(() {
                        page = const GroupHome();
                      });
                      break;
                    case 1:
                      setState(() {
                        page = const SearchScreen();
                      });
                      break;
                    case 2:
                      setState(() {
                        page = const MeetingHome();
                      });
                      break; // <-- Add break statement here
                    case 3:
                      setState(() {
                        page = const ToDoHome();
                      });
                      break; // <-- Add break statement here
                    default:
                      break;
                  }
                },
              ),
            );
    });
  }
}
