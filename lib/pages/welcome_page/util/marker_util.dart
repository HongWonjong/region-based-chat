import 'package:flutter/material.dart';
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
    required BuildContext context,
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
      setMarkerColor(marker, nMarker);
      setMarkerListener(nMarker, mapController, context, onMarkerTapped, marker);
      currentMarkers.add(nMarker);
    }
  }

  static void setMarkerColor(Marker marker, NMarker nMarker) {
    Color? color;

    switch (marker.type) {
      case StoryType.majorIncident:
        color = Colors.red;
      case StoryType.minorIncident:
        color = Colors.green;
      case StoryType.event:
        color = Colors.yellow;
        throw UnimplementedError();
      case StoryType.lostItem:
        color = Colors.blue;
    }

    nMarker.setIconTintColor(color);
  }

  static void setMarkerListener(
      NMarker nMarker, NaverMapController mapController, BuildContext context, Function(Marker) onMarkerTapped, Marker marker) {
    nMarker.setOnTapListener((NMarker tappedMarker) async {
      // 바텀 시트가 올라온 상태에서 지도 중간에 마커가 위치하기위한 좌표 보정

      // 1dp의 좌표값
      var point1 = await mapController.screenLocationToLatLng(NPoint(0.0, 0.0));
      var point2 = await mapController.screenLocationToLatLng(NPoint(0, 1));

      // 현재 화면의 사이즈 * 0.2 만큼의 길이 * 1dp의 좌표값으로 보정해야되는 수치를 구해서
      // 마커의 위치에 적용
      await mapController.updateCamera(NCameraUpdate.withParams(
          target: NLatLng(nMarker.position.latitude - MediaQuery.of(context).size.height * 0.2 * (point1.latitude - point2.latitude),
              nMarker.position.longitude)));
      onMarkerTapped(marker);
    });
  }
}
