import '../models/chat.dart';
import '../models/dummy_data_for_chat_page.dart';
import '../models/message.dart';

class ChatRepository {
  // markerId별 메시지를 관리하는 Map
  final Map<String, List<Message>> _messages = {};

  Future<Chat> getChat(String markerId) async {
    if (markerId == 'marker001') {
      return dummyChat;
    }
    throw Exception('Chat not found for markerId: $markerId');
  }

  Future<List<Message>> getMessages(String markerId) async {
    print('getMessages called with markerId: $markerId');
    if (markerId == 'marker001') {
      if (!_messages.containsKey(markerId)) {
        _messages[markerId] = List.from(dummyMessages); // 더미 메시지 복사
      }
      print('Returning messages: ${_messages[markerId]!.length} messages');
      return _messages[markerId]!;
    }
    print('Returning empty list');
    return [];
  }

  Future<void> sendMessage(String markerId, Message message) async {
    if (markerId == 'marker001') {
      if (!_messages.containsKey(markerId)) {
        _messages[markerId] = List.from(dummyMessages); // 더미 메시지 복사
      }
      _messages[markerId]!.add(message);
    }
  }

  // 메시지 초기화 메서드 (필요한 경우 사용할 것)
  void resetMessages(String markerId) {
    if (markerId == 'marker001') {
      _messages[markerId] = List.from(dummyMessages); // 더미 메시지로 초기화
    }
  }
}