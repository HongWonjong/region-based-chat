import '../models/chat.dart';
import '../models/dummy_data_for_chat_page.dart';
import '../models/message.dart';


class ChatRepository {
  Future<Chat> getChat(String markerId, String chatId) async {
    // 더미 데이터 반환 (실제로는 Firebase에서 가져옴)
    return dummyChat;
  }

  Future<List<Message>> getMessages(String markerId, String chatId) async {
    // 더미 데이터 반환 (실제로는 Firebase에서 가져옴)
    return dummyMessages;
  }

  Future<void> sendMessage(String markerId, String chatId, Message message) async {
    // 더미 데이터에서는 아무 작업 안 함 (실제로는 Firebase에 추가)
    // 예: FirebaseFirestore.instance.collection('Markers').doc(markerId)...
  }
}