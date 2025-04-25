import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:region_based_chat/models/marker.dart';

class MarkerUtils {
  static NMarker convertToNMarker(Marker marker) {
    return NMarker(
      id: marker.id,
      position: NLatLng(marker.latitude, marker.longitude),
    );
  }

  static void updateMapMarkers({
    required NaverMapController mapController,
    required Set<NMarker> currentMarkers,
    required List<Marker> newMarkers,
    required Function(Marker) onMarkerTapped,
  }) {
    // 기존 마커 제거
    for (var marker in currentMarkers) {
      mapController.deleteOverlay(marker.info);
    }
    currentMarkers.clear();

    // 새로운 마커 추가
    for (final marker in newMarkers) {
      final nMarker = convertToNMarker(marker);
      mapController.addOverlay(nMarker);
      nMarker.setOnTapListener((NMarker tappedMarker) {
        onMarkerTapped(marker);
        print(marker.title);
      });
      currentMarkers.add(nMarker);
    }
  }
}
