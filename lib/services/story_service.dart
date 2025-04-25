import 'package:cloud_firestore/cloud_firestore.dart';

enum StoryType {
  event, // 일반적인 행사
  minorIncident, // 가벼운 사건
  majorIncident, // 중요한 사건/범죄
  lostItem // 분실
}

class Story {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final DateTime createdAt;
  final StoryType type;
  final List<String> imageUrls;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.type,
    this.imageUrls = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.toString().split('.').last,
      'imageUrls': imageUrls,
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdBy: map['createdBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      type: StoryType.values.firstWhere(
          (e) => e.toString().split('.').last == map['type'],
          orElse: () => StoryType.minorIncident),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'markers';

  // 스토리 생성
  Future<String> createStory({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String userId,
    required StoryType type,
    List<String> imageUrls = const [],
  }) async {
    try {
      // 문서 ID 생성
      final docRef = _firestore.collection(_collection).doc();

      // 스토리 객체 생성
      final story = Story(
        id: docRef.id,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        createdBy: userId,
        createdAt: DateTime.now(),
        type: type,
        imageUrls: imageUrls,
      );

      // Firestore에 저장
      await docRef.set(story.toMap());

      return docRef.id;
    } catch (e) {
      print('스토리 생성 오류: $e');
      throw e;
    }
  }

  // 특정 지역의 스토리 조회 (위도/경도 범위 내)
  Future<List<Story>> getStoriesByLocation({
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
      List<Story> stories = querySnapshot.docs
          .map((doc) => Story.fromMap(doc.data()))
          .where(
              (story) => story.longitude >= minLng && story.longitude <= maxLng)
          .toList();

      return stories;
    } catch (e) {
      print('스토리 조회 오류: $e');
      throw e;
    }
  }

  // 특정 유저의 스토리 조회
  Future<List<Story>> getStoriesByUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Story.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('사용자 스토리 조회 오류: $e');
      throw e;
    }
  }
}
