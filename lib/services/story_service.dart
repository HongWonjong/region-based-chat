import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:region_based_chat/enum/story_type_enum.dart';
import 'package:region_based_chat/models/story_model.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'markers';

  // 스토리 생성
  Future<void> createStory({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String userId, // 이제 이 매개변수가 사용자 닉네임을 받음
    required StoryType type,
    required String uid,
    List<String> imageUrls = const [],
  }) async {
    try {
      // 문서 ID 생성
      final docRef = _firestore.collection(_collection).doc();

      // 스토리 객체 생성
      final story = StoryMarker(
        id: docRef.id,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        createdBy: userId, // 사용자 닉네임 저장
        createdAt: DateTime.now().toUtc().toIso8601String(),
        type: type,
        uid: uid,
        imageUrls: imageUrls,
      );

      // Firestore에 저장
      await docRef.set(story.toMap());
    } catch (e) {
      log('스토리 생성 오류: $e');
      rethrow;
    }
  }

  // 특정 지역의 스토리 조회 (위도/경도 범위 내)
  Future<List<StoryMarker>> getStoriesByLocation({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('latitude', isGreaterThanOrEqualTo: minLat)
          .where('latitude', isLessThanOrEqualTo: maxLat)
          .get();

      // 위도 필터링 후 경도 필터링 (Firebase는 다중 필드 범위 쿼리 미지원)
      List<StoryMarker> stories = querySnapshot.docs
          .map((doc) => StoryMarker.fromMap(doc.data()))
          .where(
            (story) => story.longitude >= minLng && story.longitude <= maxLng,
          )
          .toList();

      return stories;
    } catch (e) {
      log('스토리 조회 오류: $e');
      rethrow;
    }
  }

  // 특정 유저의 스토리 조회
  Future<List<StoryMarker>> getStoriesByUser(String userId) async {
    try {
      final querySnapshot =
          await _firestore.collection(_collection).where('createdBy', isEqualTo: userId).orderBy('createdAt', descending: true).get();

      return querySnapshot.docs.map((doc) => StoryMarker.fromMap(doc.data())).toList();
    } catch (e) {
      log('사용자 스토리 조회 오류: $e');
      rethrow;
    }
  }
}
