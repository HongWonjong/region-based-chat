import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:region_based_chat/enum/story_type_enum.dart';

class Marker {
  final String id;
  final String title;
  final double longitude;
  final double latitude;
  final String description;
  final String createdBy;
  final String createdAt;
  final StoryType type;
  final List<String> imageUrls;
  final String uid;

  Marker({
    required this.id,
    required this.title,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.type,
    required this.uid,
    this.imageUrls = const [],
  });
  factory Marker.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Marker(
      id: data['id'] as String,
      title: data['title'] as String,
      longitude: (data['longitude'] is int ? (data['longitude'] as int).toDouble() : data['longitude'] as double),
      latitude: (data['latitude'] is int ? (data['latitude'] as int).toDouble() : data['latitude'] as double),
      description: data['description'] as String,
      createdBy: data['createdBy'] as String,
      createdAt: data['createdAt'] as String,
      type: StoryType.fromString(data['type'] as String),
      uid: data['uid'],
      imageUrls: data['imageUrls'] != null ? List<String>.from(data['imageUrls']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'longitude': longitude,
      'latitude': latitude,
      'description': description,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'type': type.toJson(),
      'uid': uid,
      'imageUrls': imageUrls,
    };
  }
}
