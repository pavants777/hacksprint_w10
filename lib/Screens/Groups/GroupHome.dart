import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Screens/Groups/AI/ChatWithAi.dart';
import 'package:cmc/Screens/Groups/ChatPage.dart';
import 'package:cmc/Screens/Groups/CreateNewGroup.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:cmc/Utills/indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class GroupHome extends StatefulWidget {
  GroupHome({super.key});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  late List<GroupModels> groups;
  UserModels? user;
  String? uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groups = [];
    getUser();
  }

  getUser() async {
    if (mounted) {
      UserModels? userref = await FirebaseFunction.getCurrentUser(uid);
      setState(() {
        user = userref;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: appBar('GroupChats', context) as PreferredSizeWidget?,
      floatingActionButton: SpeedDial(
        backgroundColor: const Color.fromARGB(255, 5, 5, 5),
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        childPadding: EdgeInsets.only(top: 10, bottom: 10),
        onOpen: () {},
        children: [
          SpeedDialChild(
              backgroundColor: Colors.black,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AIScreen()));
              },
              child: Icon(FontAwesomeIcons.robot)),
          SpeedDialChild(
            backgroundColor: Colors.black,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateNewGroup()));
            },
            child: Icon(Icons.add),
          )
        ],
      ),
      body: _buildGroupsList(context),
    );
  }

  Widget _buildGroupsList(BuildContext context) {
    return StreamBuilder<List<GroupModels>>(
      stream: FirebaseFunction.getGroups(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Center(
            child: Text('Error Loading Groups',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Indicator();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Groups Available',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          );
        } else {
          groups = snapshot.data!;
          List<GroupModels> userGroups = groups
              .where((group) =>
                  isUserInGroup(group, FirebaseAuth.instance.currentUser!.uid))
              .toList();

          if (userGroups.isEmpty) {
            return const Center(
              child: Text(
                'You Have Not Yet Joined Any Groups',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            );
          }
          return ListView.builder(
            itemCount: userGroups.length,
            itemBuilder: (context, index) {
              return _buildGroupCard(userGroups[index], context);
            },
          );
        }
      },
    );
  }

  Widget _buildGroupCard(GroupModels group, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int hours = group.lasttimestamp?.hour ?? 0;
    int minute = group.lasttimestamp?.minute ?? 0;

    if (hours > 12) {
      hours = hours % 12;
    }

    String H = (hours < 10) ? '0$hours' : '$hours';
    String M = (minute < 10) ? '0$minute' : '$minute';
    String formattedString = '$H : $M';

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellow,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(groupId: group.groupId),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CircleAvatar(
                            maxRadius: screenWidth * 0.1,
                            backgroundColor: Colors.pink,
                            child: CircleAvatar(
                              maxRadius: screenWidth * 0.09,
                              backgroundImage:
                                  NetworkImage('${group.profileUrl}'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${group.groupName ?? ''}',
                              softWrap: false,
                              style: const TextStyle(
                                fontSize: 25,
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              ' ${group.lastMessage}',
                              softWrap: false,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formattedString,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 4,
                runSpacing: 5,
                children: group.tags
                    .take(3)
                    .map((tag) => Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 12, 52, 85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isUserInGroup(GroupModels group, String userId) {
    return group.users.any((user) => user == userId);
  }
}
