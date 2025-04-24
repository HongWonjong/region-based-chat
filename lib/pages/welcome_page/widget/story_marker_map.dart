import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:region_based_chat/pages/welcome_page/widget/focus_detector.dart';

class StoryMarkerMap extends ConsumerStatefulWidget {
  const StoryMarkerMap({super.key});

  @override
  StoryMarkerMapState createState() => StoryMarkerMapState();
}

class StoryMarkerMapState extends ConsumerState<StoryMarkerMap> with WidgetsBindingObserver {
  NaverMapController? mapController;
  final Set<NMarker> currentMarkers0 = {}; // 현재 지도에 표시된 마커 세트
  List<Marker> previousMarkers = []; // 이전 조회된 마커 리스트
  Timer? pollingTimer; // 주기적인 폴링을 위한 타이머

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isMapReady = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 위젯 바인딩 옵저버 등록
    // 5초마다 새로운 마커를 확인하는 폴링 시작
    startPollingTimer();
  }

  void startPollingTimer() {
    pollingTimer ??= Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchAndUpdateMarkers();
    });
  }

  void stopPollingTimer() {
    pollingTimer?.cancel();
    pollingTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 화면에 다시 돌아왔을 때 타이머 재개
      startPollingTimer();
    } else {
      // 화면을 보고있는 상태가 아닐때
      stopPollingTimer();
    }
  }

  Future<List<Marker>> fetchMarkers() async {
    final snapshot = await firestore.collection('markers').get();
    return snapshot.docs.map((doc) => Marker.fromFirestore(doc)).toList();
  }

  NMarker convertToNMarker(Marker marker) {
    return NMarker(
      id: marker.id,
      position: NLatLng(marker.latitude, marker.longitude),
    );
  }

  void updateMapMarkers(List<Marker> newMarkers) {
    if (mapController == null || !isMapReady) return;

    setState(() {
      // 기존 마커 제거
      for (var marker in currentMarkers0) {
        mapController!.deleteOverlay(marker.info);
      }
      currentMarkers0.clear();

      // 새로운 마커 추가
      for (final marker in newMarkers) {
        final nMarker = convertToNMarker(marker);
        mapController!.addOverlay(nMarker);
        currentMarkers0.add(nMarker);
      }
      previousMarkers = newMarkers; // 현재 마커 리스트를 이전 리스트로 업데이트
    });
  }

  Future<void> fetchAndUpdateMarkers() async {
    final currentMarkers = await fetchMarkers();

    // 이전 마커 리스트와 비교하여 새로운 마커가 있는지 확인
    final newMarkers = currentMarkers.where((marker) => !previousMarkers.any((prevMarker) => prevMarker.id == marker.id)).toList();

    if (newMarkers.isNotEmpty || currentMarkers.length != previousMarkers.length) {
      // 새로운 마커가 있거나 마커 개수가 변경되었으면 지도 업데이트
      updateMapMarkers(currentMarkers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FocusDetector(
            focusOnCallback: () => startPollingTimer(),
            focusOffCallback: () => stopPollingTimer(),
            child: NaverMap(
              onMapReady: (controller) {
                setState(() {
                  mapController = controller;
                  isMapReady = true;
                  // 맵이 준비되면 초기 데이터 로딩
                  fetchAndUpdateMarkers();
                });
              },
              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.5, 127),
                  zoom: 12,
                ),
              ),
            )),
        Positioned(right: 10, bottom: MediaQuery.of(context).size.height / 2, child: NaverMapZoomControlWidget(mapController: mapController)),
      ],
    );
  }
}
