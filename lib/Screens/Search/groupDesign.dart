import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Screens/Search/chatPage.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupDesign extends StatefulWidget {
  final String groupuid;

  const GroupDesign({Key? key, required this.groupuid}) : super(key: key);

  @override
  State<GroupDesign> createState() => _GroupDesignState();
}

class _GroupDesignState extends State<GroupDesign> {
  GroupModels? group;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    getGroup();
  }

  void getGroup() async {
    GroupModels demogroup = await FirebaseFunction.getGroup(widget.groupuid);
    setState(() {
      group = demogroup;
    });
  }

  bool userIsInGroup() {
    List<String>? groupUserIds = group?.users.map((user) => user).toList();
    return groupUserIds?.contains(currentUserId) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchChat(groupId: group!.groupId)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.yellow,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      maxRadius: screenWidth * 0.08,
                      backgroundImage: NetworkImage(
                          group?.profileUrl ?? Constant.image),
                    ),
                  ],
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group?.groupName ?? '',
                        style: const TextStyle(
                          fontSize: 25,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Members ${group?.users.length ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 17,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
