import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmc/Models/MeetingModels.dart';

class MeetingFunction {
  static Future<void> createMeeting(
    String meetingName,
    String roomId,
    List<String> joinedMembers,
    List<String> tags,
    List<String> members,
  ) async {
    try {
      CollectionReference meeting =
          FirebaseFirestore.instance.collection('meeting');

      final Timestamp timestamp = Timestamp.now();

      Map<String, dynamic> meetingData = {
        'meetingId': roomId,
        'meetingName': meetingName,
        'joinedMembers': joinedMembers,
        'tags': tags,
        'members': members,
        'lasttimestamp': timestamp,
      };

      await meeting.doc(roomId).set(meetingData);
      print('Meeting created successfully!');
    } catch (e) {
      print('Error creating meeting: $e');
    }
  }

  static Stream<List<MeetingModels>> getMeetings() async* {
    yield* FirebaseFirestore.instance
        .collection('meeting')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MeetingModels.fromJson(doc.data()))
          .toList();
    });
  }
}
