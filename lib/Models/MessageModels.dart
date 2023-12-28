import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderId;
  final bool isFile;
  Timestamp timestamp;

  Message({
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.isFile,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      senderId: json['senderId'],
      timestamp: json['timestamp'],
      isFile: json['isFile'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'senderId': senderId,
      'timestamp': timestamp,
      'isFile': isFile,
    };
  }
}
