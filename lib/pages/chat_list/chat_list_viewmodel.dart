import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 채팅방 아이템 모델
class ChatItem {
  final String id; // 채팅방 ID 추가
  final String title;
  final String lastMessage;

  ChatItem({required this.id, required this.title, required this.lastMessage});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// 채팅방 리스트 뷰모델
class ChatListViewModel extends StateNotifier<List<ChatItem>> {
  ChatListViewModel() : super([]) {
    fetchChats();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> fetchChats() async {
    try {
      // 1) 내가 가입한 마커 ID 목록 가져오기
      final userDoc = await _firestore.collection('users').doc(_myUid).get();
      final joined = userDoc.data()?['joinedMarkers'] as List<dynamic>? ?? [];

      if (joined.isEmpty) {
        state = [];
        return;
      }

      // Firestore whereIn 조건은 최대 10개만 지원하므로,
      // 10개 이하라면 whereIn, 그 이상이면 나눠서 요청
      final chunks = <List<dynamic>>[];
      for (var i = 0; i < joined.length; i += 10) {
        chunks.add(joined.sublist(i, i + 10 > joined.length ? joined.length : i + 10));
      }

      final List<ChatItem> allChats = [];
      for (var chunk in chunks) {
        final snaps = await _firestore
            .collectionGroup('Chats')
            .where('markerId', whereIn: chunk)
            .get();

        for (var doc in snaps.docs) {
          final data = doc.data();
          final chatItem = ChatItem(
            id: doc.id, // 문서 ID를 채팅방 ID로 사용
            title: data['title'] ?? 'No Title',
            lastMessage: data['lastMessage'] ?? 'No Message',
          );

          // 중복된 아이템이 없도록 체크
          if (!allChats.contains(chatItem)) {
            allChats.add(chatItem);
          }
        }
      }

      state = allChats;
    } catch (e) {
      print('Error fetching chats: $e');
      // TODO: 오류 처리 (예: 사용자에게 메시지 표시)
    }
  }
}

// Provider 설정
final chatListProvider = StateNotifierProvider<ChatListViewModel, List<ChatItem>>(
  (ref) => ChatListViewModel(),
);
