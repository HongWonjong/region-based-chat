import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:region_based_chat/enum/story_type_enum.dart';

class StoryMarker {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy; // 이제 이 필드가 사용자 닉네임을 저장
  final String createdAt; // ISO 8601 문자열로 유지
  final StoryType type;
  final String uid;
  final List<String> imageUrls;

  StoryMarker({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
    required this.type,
    required this.uid,
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
      'createdAt': createdAt,
      'type': type.toString().split('.').last,
      'uid': uid,
      'imageUrls': imageUrls,
    };
  }

  factory StoryMarker.fromMap(Map<String, dynamic> map) {
    return StoryMarker(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdBy: map['createdBy'],
      createdAt: map['createdAt'] as String,
      type: StoryType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => StoryType.minorIncident,
      ),
      uid: map['uid'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
    );
  }
}
