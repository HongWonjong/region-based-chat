import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';

class StoryBottomSheetNotifier extends FamilyNotifier<Marker, Marker> {
  @override
  Marker build(Marker initialMarker) {
    return initialMarker;
  }

  // 마커 상태를 업데이트
  void updateMarker(Marker newMarker) {
    state = newMarker;
  }
}

final storyBottomSheetProvider = NotifierProvider.family<StoryBottomSheetNotifier, Marker, Marker>(
  () => StoryBottomSheetNotifier(),
);
