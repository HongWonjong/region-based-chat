import '../models/chat.dart';
import '../models/dummy_data_for_chat_page.dart';
import '../models/message.dart';

class ChatRepository {
  Future<Chat> getChat(String markerId) async {
    // 더미 데이터 반환 (실제로는 Firebase에서 가져옴)
    if (markerId == 'marker001') {
      return dummyChat;
    }
    throw Exception('Chat not found for markerId: $markerId');
  }

  Future<List<Message>> getMessages(String markerId) async {
    print('getMessages called with markerId: $markerId');
    if (markerId == 'marker001') {
      print('Returning dummyMessages: ${dummyMessages.length} messages');
      return dummyMessages;
    }
    print('Returning empty list');
    return [];
  }

  Future<void> sendMessage(String markerId, Message message) async {
    // 더미 데이터에 메시지 추가 (실제로는 Firebase에 저장)
    if (markerId == 'marker001') {
      dummyMessages.add(message);
    }
  }
}