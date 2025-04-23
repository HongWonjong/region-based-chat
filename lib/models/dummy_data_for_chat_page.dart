import 'chat.dart';
import 'message.dart';

final dummyChat = Chat(
  markerId: 'marker001',
  title: '도난 신고',
  createdBy: 'user123',
  createdAt: DateTime.parse('2025-04-22T00:00:00Z'),
  participants: ['user123', 'user456', 'user789'],
  lastMessage: '그래 그리 쉽지는 않겠지',
  lastMessageTime: DateTime.parse('2025-04-22T10:00:00Z'),
  lastMessageSender: 'user789',
  typing: [],
);

List<Message> dummyMessages = [
  Message(
    messageId: 'msg001',
    senderId: 'user123',
    senderName: '홍길동',
    message: '너를 허락했던 세상이란',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:23:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg002',
    senderId: 'user123',
    senderName: '홍길동',
    message: '손쉽게 다가오는 평화롭고 감미로운 세상이 아냐',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:23:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg003',
    senderId: 'user456',
    senderName: '김영희',
    message: '그래도 날아오를거야',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:24:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg004',
    senderId: 'user123',
    senderName: '홍길동',
    message: '작은 날개 밑에 꿈을 달아!',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:25:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg005',
    senderId: 'user789',
    senderName: '이민혁',
    message: '조금만 기다려 봐',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:25:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
];