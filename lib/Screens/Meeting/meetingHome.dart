import 'package:cmc/Function/FirebaseFunction.dart';
import 'package:cmc/Function/meeting_function.dart';
import 'package:cmc/Models/MeetingModels.dart';
import 'package:cmc/Models/UserModels.dart';
import 'package:cmc/Screens/Meeting/LiveMeeting.dart';
import 'package:cmc/Utills/AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeetingHome extends StatefulWidget {
  const MeetingHome({super.key});

  @override
  State<MeetingHome> createState() => _MeetingHomeState();
}

class _MeetingHomeState extends State<MeetingHome> {
  List<MeetingModels>? meetings;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Meetings', context) as PreferredSizeWidget?,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _buildMeetingsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingsList() {
    return StreamBuilder<List<MeetingModels>>(
      stream: MeetingFunction.getMeetings(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Center(
            child: Text('Error Loading Meetings',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Meetings Available',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          );
        } else {
          meetings = snapshot.data!;
          return ListView.builder(
            itemCount: meetings?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildMeetingsCard(meetings![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildMeetingsCard(MeetingModels meeting) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.yellow,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${meeting.meetingName ?? ''}',
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 25,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                    onPressed: () async {
                      UserModels? user = await FirebaseFunction.getCurrentUser(
                          FirebaseAuth.instance.currentUser!.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LivePage(
                                    roomID: meeting.meetingId,
                                    userName: 'Pavan',
                                    userUid: user!.uid,
                                    profilePhoto: user!.profilePhoto,
                                    isHost: false,
                                  )));
                    },
                    child: const Text('Join'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 0, 2, 125)),
                    ))),
            Container(
              width: screenWidth,
              height: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                spacing: 4,
                runSpacing: 5,
                children: meeting.tags
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
}
