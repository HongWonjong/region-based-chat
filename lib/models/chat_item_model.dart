// 채팅방 아이템 모델
class ChatItemModel {
  final String id; // markerId
  final String title;
  final String lastMessage;

  ChatItemModel({required this.id, required this.title, required this.lastMessage});

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChatItemModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
