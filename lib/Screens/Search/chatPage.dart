import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Function/FirebaseGroup_function.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Provider/UserProvider.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class SearchChat extends StatefulWidget {
  final String groupId;

  const SearchChat({Key? key, required this.groupId}) : super(key: key);

  @override
  State<SearchChat> createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  TextEditingController _message = TextEditingController();
  late bool checkUser;
  GroupModels? group;
  late UserProvider _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserProvider>(context, listen: false);
    getGroup();
    checkUser = checkUserInGroup();
    // Initialize checkUser after fetching data
  }

  void getGroup() async {
    GroupModels demo = await FirebaseFunction.getGroup(widget.groupId);
    setState(() {
      group = demo;
      checkUser = checkUserInGroup();
    });
  }

  bool checkUserInGroup() {
    bool userPresence =
        group?.users.map((e) => (e)).contains(_user.user!.uid) ?? false;
    return userPresence;
  }

  _sendMessagetoGroup() async {
    if (_message.text.isNotEmpty) {
      await FirebaseGroupFunction.sendMessagetoGroup(
        widget.groupId,
        _message.text,
      );
      _message.clear();
      setState(() {
        checkUser = checkUserInGroup();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 200,
        title: Row(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.05,
                      backgroundColor: Colors.pink,
                      child: CircleAvatar(
                        maxRadius: screenWidth * 0.045,
                        backgroundImage: NetworkImage(
                          '${group?.profileUrl ?? Constant.image}',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${group?.groupName ?? ''}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Total Members : ${group?.users?.length}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.green.shade500,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseGroupFunction.getMessageFromGroup(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                List<DocumentSnapshot<Map<String, dynamic>>> messages =
                    snapshot.data!.docs;
                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs
                      .map((e) => _buildMessageItem(e))
                      .toList(),
                );
              },
            ),
          ),
          !checkUser ? _buildJoin(screenWidth) : _typing(screenWidth),
        ],
      ),
    );
  }

  Widget _buildJoin(double screenWidth) {
    return GestureDetector(
      onTap: () {
        FirebaseGroupFunction.addMemberstoGroup(
          FirebaseAuth.instance.currentUser!.uid,
          group!.groupId,
        );
        setState(() {
          checkUser = !checkUser;
        });
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
        height: 60,
        width: screenWidth,
        child: const Center(
          child: Text(
            'Join',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              letterSpacing: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _typing(double screenWidth) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _message,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: const TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.only(left: screenWidth * 0.2),
                filled: true,
                fillColor: Colors.grey.shade100,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _sendMessagetoGroup();
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = timestamp.toDate();
    int hours = dateTime.hour;
    int minute = dateTime.minute;
    bool isMorning = true;

    if (hours > 12) {
      hours = hours % 12;
      isMorning = false;
    }

    String period = isMorning ? 'AM' : 'PM';
    String formattedString = '$hours : $minute $period';

    Color _color = (data['senderId'] == _auth.currentUser!.uid)
        ? const Color.fromARGB(255, 172, 247, 175)
        : Colors.white;

    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return !data['isFile']
        ? StreamBuilder<UserModels?>(
            stream: Stream.fromFuture(
                FirebaseFunction.getCurrentUser(data['senderId'])),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                UserModels? user = snapshot.data;
                return Container(
                  alignment: alignment,
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      crossAxisAlignment:
                          (data['senderId'] == _auth.currentUser!.uid)
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      mainAxisAlignment:
                          (data['senderId'] == _auth.currentUser!.uid)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: _color,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user?.userName ?? ''}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  data['message'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedString,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          )
        : StreamBuilder<UserModels?>(
            stream: Stream.fromFuture(
                FirebaseFunction.getCurrentUser(data['senderId'])),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                UserModels? user = snapshot.data;
                return GestureDetector(
                  onTap: () {
                    _downloadFile(data['message']);
                  },
                  child: Container(
                    alignment: alignment,
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        crossAxisAlignment:
                            (data['senderId'] == _auth.currentUser!.uid)
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        mainAxisAlignment:
                            (data['senderId'] == _auth.currentUser!.uid)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: _color,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user?.userName ?? ''}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      FontAwesomeIcons.filePdf,
                                      color: Colors.red,
                                    )),
                                Text(
                                  data['message'] ?? '',
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formattedString,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
  }

  Future _downloadFile(String fileName) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('files/$fileName');
      String downloadUrl = await ref.getDownloadURL();
      print(downloadUrl);

      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/${fileName}';

      await Dio().download(downloadUrl, path);

      if (downloadUrl.contains('.mp4')) {
        await GallerySaver.saveVideo(path, toDcim: true);
      } else if (downloadUrl.contains('.jpg') || fileName.contains('.jpeg')) {
        await GallerySaver.saveImage(path, toDcim: true);
      } else if (fileName.contains('.pdf')) {
        await OpenFile.open(path);
      }
      await OpenFile.open(path);
    } catch (error) {
      print('Error getting download URL: $error');
    }
  }

  getTemporaryDirectory() {}
}
