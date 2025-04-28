import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String senderId;
  final String senderName;
  final String message;
  final String type;
  final DateTime timestamp;
  final List<String> readBy;

  Message({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.readBy,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      message: json['message'],
      type: json['type'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      readBy: List<String>.from(json['readBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
    };
  }
}