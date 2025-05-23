// Provider 설정
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_item_model.dart';
import '../pages/chat_list_page/chat_list_view_model.dart';

final chatListProvider = StateNotifierProvider<ChatListViewModel, List<ChatItemModel>>(
      (ref) => ChatListViewModel(),
);