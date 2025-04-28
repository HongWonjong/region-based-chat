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

  Chat({
    required this.markerId,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSender,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      markerId: json['markerId'],
      title: json['title'],
      createdBy: json['createdBy'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      participants: List<String>.from(json['participants']),
      lastMessage: json['lastMessage'],
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSender: json['lastMessageSender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'markerId': markerId,
      'title': title,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessageSender': lastMessageSender,
    };
  }
}