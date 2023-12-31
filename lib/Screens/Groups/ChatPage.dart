import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Function/FirebaseGroup_function.dart';
import 'package:cmc/Models/GroupModels.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Screens/Meeting/CreateMeeting.dart';
import 'package:cmc/Screens/ToDo/createtodo.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:cmc/Utills/PickFile.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  String groupId;
  ChatPage({super.key, required this.groupId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _message = TextEditingController();
  GroupModels? group;
  List<UserModels> users = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isAdmin = false;
  final StreamController _messageStreamController = StreamController();
  late Stream _messageStream;

  // Rest of the code...

  void initState() {
    super.initState();
    _messageStream = FirebaseGroupFunction.getMessageFromGroup(widget.groupId);
    initializeData();
  }

  Future<void> initializeData() async {
    await getUser();
    isAdmin = getAdmin();
    print(isAdmin);
  }

  bool getAdmin() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print(group?.isAdmin);
    print(uid);
    if (group?.isAdmin == uid) {
      return true;
    }
    return false;
  }

  Future<void> getUser() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    GroupModels demogroup =
        await FirebaseGroupFunction.getGroup(widget.groupId);
    setState(() {
      group = demogroup;
      users = querySnapshot.docs
          .map((doc) => UserModels.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  _sendMessagetoGroup() async {
    if (_message.text.isNotEmpty) {
      await FirebaseGroupFunction.sendMessagetoGroup(
          widget.groupId, _message.text);
      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 200,
        title: Row(children: [
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
                          '${group?.profileUrl ?? Constant.image}'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: List.generate(
                                  ((group?.users.length ?? 0) > 3)
                                      ? 3
                                      : (group?.users.length ?? 0),
                                  (index) => Transform.translate(
                                      offset: Offset((index) * 15.0, 0),
                                      child: Avthar(uid: group!.users[index])),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Text(
                                '${group?.users.length}+ Joined',
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 15),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        actions: [
          isAdmin
              ? PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (BuildContext context) {
                    return [
                      _buildPopupMenuItem(
                        icon: FontAwesomeIcons.video,
                        text: 'Create New Meeting',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateRoom(
                                        group: group,
                                      )));
                        },
                      ),
                      _buildPopupMenuItem(
                        icon: FontAwesomeIcons.tasks,
                        text: 'Create New Work',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateToDo(group: group)));
                        },
                      ),
                    ];
                  },
                )
              : Container(),
          IconButton(
            onPressed: () {
              String uid = FirebaseAuth.instance.currentUser!.uid;
              FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .update({
                'users': FieldValue.arrayRemove([uid]),
              });
            },
            icon: Icon(Icons.exit_to_app),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
            stream: _messageStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              List<DocumentSnapshot<Map<String, dynamic>>> messages =
                  snapshot.data!.docs;
              return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // Make sure to convert each item to a Widget
                  return _buildMessageItem(messages[index]);
                },
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _message,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.black),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PickFile(
                                    groupId: widget.groupId,
                                  )));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                    ))),
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
                    ))),
          ],
        ),
      ]),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
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

  PopupMenuItem<String> _buildPopupMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem<String>(
      onTap: onTap,
      value: text,
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          const SizedBox(width: 30),
          Text(
            text,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
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
}

class Avthar extends StatefulWidget {
  final String uid;

  Avthar({Key? key, required this.uid}) : super(key: key);

  @override
  State<Avthar> createState() => _AvtharState();
}

class _AvtharState extends State<Avthar> {
  UserModels? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void getUser() async {
    UserModels? userref = await FirebaseFunction.getCurrentUser(widget.uid);
    if (mounted) {
      setState(() {
        user = userref;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 10,
      backgroundImage: NetworkImage(user?.profilePhoto ?? Constant.image),
    );
  }
}
