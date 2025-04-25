import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Marker {
  final String id;
  final String title;
  final double longitude;
  final double latitude;
  final String description;
  final String createdBy;
  final String createdAt;
  final StoryType type;

  Marker({
    required this.id,
    required this.title,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.type,
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
    };
  }
}

enum StoryType {
  majorIncident('majorIncident', '범죄', Color(0xFFF44336)),
  minorIncident('minorIncident', '사건/사고', Color(0xFF4CAF50)),
  event('event', '행사', Color(0xFFFFEB3B)),
  lostItem('lostItem', '분실', Color(0xFF2196F3));

  const StoryType(this.type, this.typeKor, this.color);
  final String type;
  final String typeKor;
  final Color color;
  factory StoryType.fromString(String typeString) {
    switch (typeString) {
      case 'majorIncident':
        return StoryType.majorIncident;
      case 'minorIncident':
        return StoryType.minorIncident;
      case 'event':
        return StoryType.event;
      case 'lostItem':
        return StoryType.lostItem;
      default:
        throw ArgumentError('Unknown StoryType: $typeString');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}
