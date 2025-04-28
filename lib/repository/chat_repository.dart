import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat.dart';
import '../models/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Chat> getOrCreateChat(String markerId, String userId, String userName) async {
    final chatRef = _firestore.collection('markers').doc(markerId).collection('Chats');
    final chatDocRef = chatRef.doc('default');
    final querySnapshot = await chatRef.get();

    // 유저의 joinedMarkers 업데이트 함수
    Future<void> updateUserJoinedMarkers(String userId, String markerId) async {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'joinedMarkers': FieldValue.arrayUnion([markerId]),
      });
    }

    if (querySnapshot.docs.isNotEmpty) {
      // 기존 채팅방이 있는 경우
      final doc = querySnapshot.docs.first;
      final chatData = doc.data();

      // participants에 userId가 없으면 추가
      if (!chatData['participants'].contains(userId)) {
        await chatDocRef.update({
          'participants': FieldValue.arrayUnion([userId]),
        });
        // 유저의 joinedMarkers에 markerId 추가
        await updateUserJoinedMarkers(userId, markerId);
      }

      // 업데이트된 채팅 데이터 반환
      final updatedDoc = await chatDocRef.get();
      return Chat.fromJson(updatedDoc.data()!);
    } else {
      // 마커 문서에서 title 조회
      String title = '알 수 없는 제목';
      try {
        final markerDoc = await _firestore.collection('markers').doc(markerId).get();
        if (markerDoc.exists && markerDoc.data() != null) {
          title = markerDoc.data()!['title'] ?? title;
        }
      } catch (e) {
        print('Error fetching marker title: $e');
      }

      // 새로운 채팅방 생성
      final newChat = Chat(
        markerId: markerId,
        title: title,
        createdBy: userId,
        createdAt: DateTime.now(),
        participants: [userId],
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        lastMessageSender: '',
      );
      await chatDocRef.set(newChat.toJson());

      // 유저의 joinedMarkers에 markerId 추가
      await updateUserJoinedMarkers(userId, markerId);

      return newChat;
    }
  }

  // 메시지 스트림 제공
  Stream<List<Message>> getMessages(String markerId) {
    return _firestore
        .collection('markers')
        .doc(markerId)
        .collection('Chats')
        .doc('default')
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromJson(doc.data()))
        .toList());
  }

  // 메시지 전송
  Future<void> sendMessage(String markerId, Message message) async {
    final chatRef = _firestore
        .collection('markers')
        .doc(markerId)
        .collection('Chats')
        .doc('default');
    final messageRef = chatRef.collection('Messages').doc();

    // 메시지 저장
    await messageRef.set({
      ...message.toJson(),
      'messageId': messageRef.id, // Firestore 자동 ID 사용
    });

    // 채팅방 lastMessage 업데이트
    await chatRef.update({
      'lastMessage': message.message,
      'lastMessageTime': Timestamp.fromDate(message.timestamp),
      'lastMessageSender': message.senderId,
    });
  }

  // 이미지 업로드
  Future<String> uploadImage(String markerId, String messageId, XFile image) async {
    final ref = _storage.ref().child('chats/$markerId/messages/$messageId/image.jpg');
    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }

// 사용자 프로필 이미지 URL 가져오기
  Future<String?> getProfileImageUrl(String userId) async {
    try {
      final ref = _storage.ref().child('users/profileImages/$userId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching profile image URL: $e');
      return null; // 프로필 이미지가 없는 경우
    }
  }
}