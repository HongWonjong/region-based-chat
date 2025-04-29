import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../pages/auth/auth_provider.dart';
import '../repository/chat_repository.dart';

class ChatParams {
  final String markerId;

  ChatParams(this.markerId);

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatParams && markerId == other.markerId;

  @override
  int get hashCode => markerId.hashCode;
}

class ChatNotifier extends StateNotifier<List<Message>> {
  final ChatRepository _repository;
  final String markerId;
  final Ref _ref;
  Chat? _chat;

  ChatNotifier(this._repository, this.markerId, this._ref) : super([]) {
    _loadData();
  }

  Chat? get chat => _chat;

  Future<void> _loadData() async {
    try {
      final user = _ref.read(authProvider);
      if (user == null) {
        log('User not logged in');
        return;
      }
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['username'] ?? 'Unknown';

      _chat = await _repository.getOrCreateChat(markerId, user.uid, userName);
      _repository.getMessages(markerId).listen((messages) {
        state = messages;
      });
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  Future<void> sendMessage(String message, String type) async {
    try {
      final user = _ref.read(authProvider);
      if (user == null) {
        log('User not logged in');
        return;
      }
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['username'] ?? 'Unknown';

      final newMessage = Message(
        messageId: '', // Firestore에서 자동 생성
        senderId: user.uid,
        senderName: userName,
        message: message,
        type: type,
        timestamp: DateTime.now(),
        readBy: [user.uid],
      );
      await _repository.sendMessage(markerId, newMessage);
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  Future<void> sendImage(XFile image) async {
    try {
      final user = _ref.read(authProvider);
      if (user == null) {
        log('User not logged in');
        return;
      }
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['username'] ?? 'Unknown';

      final messageId = DateTime.now().millisecondsSinceEpoch.toString(); // 임시 ID
      final imageUrl = await _repository.uploadImage(markerId, messageId, image);
      final newMessage = Message(
        messageId: '', // Firestore에서 자동 생성
        senderId: user.uid,
        senderName: userName,
        message: imageUrl,
        type: 'image',
        timestamp: DateTime.now(),
        readBy: [user.uid],
      );
      await _repository.sendMessage(markerId, newMessage);
    } catch (e) {
      log('Error sending image: $e');
    }
  }
}

final chatRepositoryProvider = Provider((ref) => ChatRepository());

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, List<Message>, ChatParams>(
  (ref, params) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repository, params.markerId, ref);
  },
);

final chatProvider = FutureProvider.family<Chat?, ChatParams>((ref, params) async {
  final repository = ref.watch(chatRepositoryProvider);
  final user = ref.read(authProvider);
  if (user == null) return null;
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  final userName = userDoc.data()?['username'] ?? 'Unknown';
  return await repository.getOrCreateChat(params.markerId, user.uid, userName);
});
