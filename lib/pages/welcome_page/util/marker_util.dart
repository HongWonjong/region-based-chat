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
      nMarker.setOnTapListener((NMarker tappedMarker) async {
        // 바텀 시트가 올라온 상태에서 지도 중간에 마커가 위치하기위한 좌표 보정
        NCameraPosition position = await mapController.getCameraPosition();
        var point1 = await mapController.screenLocationToLatLng(NPoint(0.5, 0.5));
        var point2 = await mapController.screenLocationToLatLng(NPoint(0.5, 0.4));
        await mapController.updateCamera(NCameraUpdate.withParams(
            target:
                NLatLng(nMarker.position.latitude - 350 * (point2.latitude - point1.latitude) * (21 - position.zoom), nMarker.position.longitude)));
        onMarkerTapped(marker);
      });
      currentMarkers.add(nMarker);
    }
  }
}
