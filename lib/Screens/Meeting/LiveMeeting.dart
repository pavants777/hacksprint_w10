import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Routes/page_routes.dart';
import 'package:cmc/Utills/CompanyLogo.dart';
import 'package:cmc/Utills/Constant.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class LivePage extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userName;
  final String userUid;
  final String profilePhoto;

  const LivePage(
      {Key? key,
      required this.roomID,
      this.isHost = false,
      required this.userName,
      required this.userUid,
      required this.profilePhoto})
      : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: Constant.appId,
        appSign: Constant.appSign,
        userID: widget.userUid,
        userName: widget.userName,
        roomID: widget.roomID,
        config: widget.isHost
            ? (ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
              ..confirmDialogInfo = ZegoDialogInfo(
                title: "Leave the room",
                message: "Are you sure to leave the room?",
                cancelButtonName: "Cancel",
                confirmButtonName: "Leave",
              )
              ..onLeaveConfirmation = (BuildContext context) async {
                await FirebaseFirestore.instance
                    .collection('meeting')
                    .doc(widget.roomID)
                    .delete();
                Navigator.pushReplacementNamed(context, Routes.meeting);
                return true;
              })
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
          ..userAvatarUrl = widget.profilePhoto,
      ),
    );
  }
}
