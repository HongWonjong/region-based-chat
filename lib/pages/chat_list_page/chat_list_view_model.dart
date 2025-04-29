import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/chat_item_model.dart';



class ChatListViewModel extends StateNotifier<List<ChatItemModel>> {
  ChatListViewModel() : super([]) {
    fetchChats();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _myUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> fetchChats() async {
    try {
      // 내 user 문서에서 마커 ID 목록 가져오기
      final userDoc = await _firestore.collection('users').doc(_myUid).get();
      final joined = userDoc.data()?['joinedMarkers'] as List<dynamic>? ?? [];

      if (joined.isEmpty) {
        state = [];
        return;
      }

      // 각 markerId에 대해 Chats/default 문서 가져오기
      final List<ChatItemModel> allChats = [];
      for (var markerId in joined) {
        try {
          final chatDoc = await _firestore
              .collection('markers')
              .doc(markerId)
              .collection('Chats')
              .doc('default')
              .get();

          if (chatDoc.exists) {
            final data = chatDoc.data()!;
            final chatItem = ChatItemModel(
              id: markerId, // markerId를 채팅방 ID로 사용
              title: data['title'] ?? 'No Title',
              lastMessage: data['lastMessage'] ?? 'No Message',
            );
            allChats.add(chatItem);
          }
          // 문서가 없으면(삭제된 채팅방인 경우 대비)을 건너뜀
        } catch (e) {
          // 개별 markerId 오류는 무시하고 다음으로 진행
          continue;
        }
      }

      state = allChats;
    } catch (e) {
      state = [];
    }
  }
}