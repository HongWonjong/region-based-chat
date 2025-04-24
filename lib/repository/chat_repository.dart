import '../models/chat.dart';
import '../models/dummy_data_for_chat_page.dart';
import '../models/message.dart';

class ChatRepository {
  Future<Chat> getChat(String markerId, String chatId) async {
    // 더미 데이터 반환 (실제로는 Firebase에서 가져옴)
    if (markerId == 'marker001' && chatId == 'chat001') {
      return dummyChat;
    }
    throw Exception('Chat not found for markerId: $markerId, chatId: $chatId');
  }

  Future<List<Message>> getMessages(String markerId, String chatId) async {
    print('getMessages called with markerId: $markerId, chatId: $chatId');
    if (markerId == 'marker001' && chatId == 'chat001') {
      print('Returning dummyMessages: ${dummyMessages.length} messages');
      return dummyMessages;
    }
    print('Returning empty list');
    return [];
  }

  Future<void> sendMessage(String markerId, String chatId, Message message) async {
    // 더미 데이터에 메시지 추가 (실제로는 Firebase에 저장)
    if (markerId == 'marker001' && chatId == 'chat001') {
      dummyMessages.add(message);
    }
  }
}