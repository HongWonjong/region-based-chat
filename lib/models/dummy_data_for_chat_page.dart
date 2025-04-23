import 'chat.dart';
import 'message.dart';

final dummyChat = Chat(
  markerId: 'marker001',
  title: '도난 신고',
  createdBy: 'user123',
  createdAt: DateTime.parse('2025-04-22T00:00:00Z'),
  participants: ['user123', 'user456', 'user789'],
  lastMessage: '대문에 맞았기 때문에 간나다 ㄱㅏ',
  lastMessageTime: DateTime.parse('2025-04-22T10:00:00Z'),
  lastMessageSender: 'user789',
  typing: [],
);

final dummyMessages = [
  Message(
    messageId: 'msg001',
    senderId: 'user123',
    senderName: '홍길동',
    message: '전화번호 안가져오대?',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:23:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg002',
    senderId: 'user123',
    senderName: '홍길동',
    message: '교회 안가서 잔뜩부족했어',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:23:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg003',
    senderId: 'user456',
    senderName: '김영희',
    message: '파리바게트 열린다!',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:24:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg004',
    senderId: 'user123',
    senderName: '홍길동',
    message: '감사합니다!',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:25:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
  Message(
    messageId: 'msg005',
    senderId: 'user789',
    senderName: '이민혁',
    message: '대문에 맞았기 때문에 간나다 ㄱㅏ',
    type: 'text',
    timestamp: DateTime.parse('2025-04-22T04:25:00Z'),
    readBy: ['user123', 'user456', 'user789'],
  ),
];