import 'dart:ui';

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
