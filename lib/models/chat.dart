import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String markerId;
  final String title;
  final String createdBy;
  final DateTime createdAt;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSender;
  final List<String> typing;

  Chat({
    required this.markerId,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSender,
    required this.typing,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      markerId: json['markerId'],
      title: json['title'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      participants: List<String>.from(json['participants']),
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessageSender: json['lastMessageSender'],
      typing: List<String>.from(json['typing']),
    );
  }
}