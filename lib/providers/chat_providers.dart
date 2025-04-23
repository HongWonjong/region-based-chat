import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../repository/chat_repository.dart';


class ChatNotifier extends StateNotifier<List<Message>> {
  final ChatRepository _repository;
  final String markerId;
  final String chatId;
  Chat? _chat;

  ChatNotifier(this._repository, this.markerId, this.chatId) : super([]) {
    _loadChat();
    _loadMessages();
  }

  Chat? get chat => _chat;

  Future<void> _loadChat() async {
    _chat = await _repository.getChat(markerId, chatId);
  }

  Future<void> _loadMessages() async {
    state = await _repository.getMessages(markerId, chatId);
  }

  Future<void> sendMessage(String senderId, String senderName, String message, String type) async {
    final newMessage = Message(
      messageId: 'msg${state.length + 1}', // 더미 ID 생성
      senderId: senderId,
      senderName: senderName,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      readBy: [senderId],
    );
    await _repository.sendMessage(markerId, chatId, newMessage);
    state = [...state, newMessage];
  }
}

final chatRepositoryProvider = Provider((ref) { return ChatRepository(); });

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, List, Map<String, String>>((ref, params) { final repository = ref.watch(chatRepositoryProvider); return ChatNotifier(repository, params['markerId']!, params['chatId']!); });