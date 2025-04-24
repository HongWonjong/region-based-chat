import 'dart:ui';

class Marker {
  final String id;
  final String title;
  final double longitude;
  final double latitude;
  final String description;
  final String createdBy;
  final String createdAt;
  final StoryType storyType;

  Marker({
    required this.id,
    required this.title,
    required this.longitude,
    required this.latitude,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.storyType,
  });
  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'] as String,
      title: json['title'] as String,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      description: json['description'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      storyType: StoryType.fromJson(json['storyType'] as Map<String, dynamic>),
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
      'storyType': storyType.toJson(),
    };
  }
}

enum StoryType {
  majorIncident('majorIncident', Color(0xFFF44336)),
  minorIncident('minorIncident', Color(0xFF4CAF50)),
  event('event', Color(0xFFFFEB3B)),
  lostItem('lostItem', Color(0xFF2196F3));

  const StoryType(this.type, this.color);
  final String type;
  final Color color;

  factory StoryType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'majorIncident':
        return StoryType.majorIncident;
      case 'minorIncident':
        return StoryType.minorIncident;
      case 'event':
        return StoryType.event;
      case 'lostItem':
        return StoryType.lostItem;
      default:
        throw ArgumentError('Unknown StoryType: ${json['type']}');
    }
  }

  Map<String, dynamic> toJson() {
    return {'type': type};
  }
}
