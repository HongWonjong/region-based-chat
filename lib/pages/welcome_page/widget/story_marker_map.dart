import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'
    hide NaverMapZoomControlWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/marker.dart';
import '../../../providers/marker_provider.dart';
import '../util/polling_timer.dart';
import 'focus_detector.dart';
import 'naver_map_zoom_control.dart';

class StoryMarkerMap extends ConsumerStatefulWidget {
  final DraggableScrollableController draggableController;

  const StoryMarkerMap({super.key, required this.draggableController});

  @override
  StoryMarkerMapState createState() => StoryMarkerMapState();
}

class StoryMarkerMapState extends ConsumerState<StoryMarkerMap>
    with WidgetsBindingObserver {
  NaverMapController? mapController;
  final PollingTimer pollingTimer = PollingTimer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      _loadInitialMarkers();
    });
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

  void startPollingTimer() {
    pollingTimer.start(const Duration(seconds: 5), () {
      ref.read(markerListProvider.notifier).fetchMarkers(
          mapController!, MediaQuery.of(context).size.height, _onMarkerTapped);
    });
  }

  void stopPollingTimer() {
    pollingTimer.stop();
  }

  @override
  void dispose() {
    stopPollingTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadInitialMarkers() async {
    startPollingTimer();
  }

  void _onMarkerTapped(Marker tappedMarker) {
    log("마커 탭 감지");
    widget.draggableController.animateTo(0.6,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    ref.read(selectedMarkerProvider.notifier).state = tappedMarker; // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        _customNaverMap(isDark),
        _customNaverMapZoom(context),
      ],
    );
  }

  Positioned _customNaverMapZoom(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: MediaQuery.of(context).size.height / 1.8,
      child: NaverMapZoomControlWidget(mapController: mapController),
    );
  }

  FocusDetector _customNaverMap(bool isDark) {
    return FocusDetector(
        focusOnCallback: () => startPollingTimer(),
        focusOffCallback: () => stopPollingTimer(),
        child: NaverMap(
          forceGesture: true,
          onMapReady: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          onCameraChange: (NCameraUpdateReason reason, __) {
            if (reason != NCameraUpdateReason.developer) {
              widget.draggableController.animateTo(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          },
          onMapTapped: (_, __) {
            widget.draggableController.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          options: NaverMapViewOptions(
            liteModeEnable: false,
            initialCameraPosition: const NCameraPosition(
              target: NLatLng(37.5, 127),
              zoom: 12,
            ),
            nightModeEnable: isDark, // 다크모드 상태에 따라 야간 모드 활성화
            mapType: NMapType.navi, // 항상 네비 타입으로 설정
          ),
        ));
  }
}
