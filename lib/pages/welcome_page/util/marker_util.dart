import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:region_based_chat/enum/story_type_enum.dart';
import 'package:region_based_chat/models/story_model.dart';

class MarkerUtils {
  static NMarker convertToNMarker(StoryMarkerModel story) {
    return NMarker(
      id: story.id,
      position: NLatLng(story.latitude, story.longitude),
    );
  }

  static void updateMapMarkers(
      {required NaverMapController mapController,
      required List<StoryMarkerModel> removedMarkers,
      required List<StoryMarkerModel> addedMarkers,
      required Function(StoryMarkerModel) onMarkerTapped,
      required double positonCorrectionValue}) {
    // 마커 제거
    for (var marker in removedMarkers) {
      mapController.deleteOverlay(convertToNMarker(marker).info);
    }
    // 마커 추가
    for (final marker in addedMarkers) {
      final nMarker = convertToNMarker(marker);
      mapController.addOverlay(nMarker);
      setMarkerVisual(marker, nMarker);
      setMarkerListener(nMarker, mapController, positonCorrectionValue, onMarkerTapped, marker);
    }
  }

  static void setMarkerVisual(StoryMarkerModel story, NMarker nMarker) {
    Color? color;

    switch (story.type) {
      case StoryType.majorIncident:
        color = Colors.red;
        break;
      case StoryType.minorIncident:
        color = Colors.green;
        break;
      case StoryType.event:
        color = Colors.yellow;
        break;
      case StoryType.lostItem:
        color = Colors.blue;
        break;
    }
    nMarker.setIcon(const NOverlayImage.fromAssetImage('assets/marker_black.png'));
    nMarker.setSize(const Size(35, 50));
    nMarker.setIconTintColor(color);
  }

  static void setMarkerListener(NMarker nMarker, NaverMapController mapController, double positonCorrectionValue,
      Function(StoryMarkerModel) onMarkerTapped, StoryMarkerModel marker) {
    nMarker.setOnTapListener((NMarker tappedMarker) async {
      // 바텀 시트가 올라온 상태에서 지도 중간에 마커가 위치하기위한 좌표 보정

      // 1dp의 좌표값
      var point1 = await mapController.screenLocationToLatLng(NPoint(0.0, 0.0));
      var point2 = await mapController.screenLocationToLatLng(NPoint(0, 1));

      // 현재 화면의 사이즈 * 0.2 만큼의 길이 * 1dp의 좌표값으로 보정해야되는 수치를 구해서
      // 마커의 위치에 적용
      await mapController.updateCamera(NCameraUpdate.withParams(
          target:
              NLatLng(nMarker.position.latitude - positonCorrectionValue * 0.2 * (point1.latitude - point2.latitude), nMarker.position.longitude)));
      onMarkerTapped(marker);
    });
  }
}
