import 'dart:developer';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:region_based_chat/pages/welcome_page/util/marker_util.dart';
import 'package:region_based_chat/providers/firebase_store_provider.dart';
import 'package:region_based_chat/repository/marker_repository.dart';

// 마커 리스트 상태 관리
final markerListProvider = StateNotifierProvider<MarkerListNotifier, List<Marker>>((ref) {
  final markerRepository = ref.watch(markerRepositoryProvider); // MarkerRepository를 주입받음
  return MarkerListNotifier(markerRepository);
});

// 선택된 마커 상태 관리
final selectedMarkerProvider = StateProvider<Marker?>((ref) => null);

// 마커 리스트 상태 관리용 Notifier
class MarkerListNotifier extends StateNotifier<List<Marker>> {
  final MarkerRepository markerRepository;

  MarkerListNotifier(this.markerRepository) : super([]);

  Future<void> fetchMarkers(NaverMapController controller, double positonCorrectionValue, Function(Marker) onMarkerTapped) async {
    log('fetch markers');
    final markers = await markerRepository.fetchMarkers(); // MarkerRepository에서 가져온 데이터

    // 추가된 마커와 삭제된 마커를 분리
    final [addedMarkers, removedMarkers] = _getNewAndRemovedMarkers(state, markers);

    // 추가된 마커와 삭제된 마커를 지도에 반영
    MarkerUtils.updateMapMarkers(
        mapController: controller,
        positonCorrectionValue: positonCorrectionValue,
        addedMarkers: addedMarkers,
        removedMarkers: removedMarkers,
        onMarkerTapped: onMarkerTapped);

    // 상태를 새로운 마커 리스트로 업데이트
    state = markers;
  }

  List<List<Marker>> _getNewAndRemovedMarkers(List<Marker> currentMarkers, List<Marker> newMarkers) {
    final currentMarkerIds = currentMarkers.map((marker) => marker.id).toSet();
    final newMarkerIds = newMarkers.map((marker) => marker.id).toSet();

    final addedMarkerIds = newMarkerIds.difference(currentMarkerIds);
    final removedMarkerIds = currentMarkerIds.difference(newMarkerIds);

    final addedMarkers = newMarkers.where((marker) => addedMarkerIds.contains(marker.id)).toList();
    final removedMarkers = currentMarkers.where((marker) => removedMarkerIds.contains(marker.id)).toList();

    return [addedMarkers, removedMarkers];
  }
}
