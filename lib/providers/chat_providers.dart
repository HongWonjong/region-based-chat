import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../repository/chat_repository.dart';

class ChatParams {
  final String markerId;
  final String chatId;

  ChatParams(this.markerId, this.chatId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatParams &&
              markerId == other.markerId &&
              chatId == other.chatId;

  @override
  int get hashCode => markerId.hashCode ^ chatId.hashCode;
}

class ChatNotifier extends StateNotifier<List<Message>> {
  final ChatRepository _repository;
  final String markerId;
  final String chatId;
  Chat? _chat;

  ChatNotifier(this._repository, this.markerId, this.chatId) : super([]) {
    _loadData();
  }

  Chat? get chat => _chat;

  Future<void> _loadData() async {
    try {
      _chat = await _repository.getChat(markerId, chatId);
      state = await _repository.getMessages(markerId, chatId);
      print('Chat loaded: ${_chat?.title}, Messages: ${state.length}');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> sendMessage(String senderId, String senderName, String message, String type) async {
    try {
      final newMessage = Message(
        messageId: 'msg${state.length + 1}',
        senderId: senderId,
        senderName: senderName,
        message: message,
        type: type,
        timestamp: DateTime.now(),
        readBy: [senderId],
      );
      await _repository.sendMessage(markerId, chatId, newMessage);
      state = [...state, newMessage];
      print('Message sent: ${newMessage.message}');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

final chatRepositoryProvider = Provider((ref) => ChatRepository());

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, List<Message>, ChatParams>(
      (ref, params) {
    final repository = ref.watch(chatRepositoryProvider);
    return ChatNotifier(repository, params.markerId, params.chatId);
  },
);

final chatProvider = FutureProvider.family<Chat?, ChatParams>((ref, params) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getChat(params.markerId, params.chatId);
});