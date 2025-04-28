import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:region_based_chat/pages/welcome_page/util/marker_util.dart';
import 'package:region_based_chat/pages/welcome_page/util/polling_timer.dart';
import 'package:region_based_chat/pages/welcome_page/widget/focus_detector.dart';
import 'package:region_based_chat/providers/marker_provider.dart';
import 'package:region_based_chat/services/firebase_firestore_service.dart';

class StoryMarkerMap extends ConsumerStatefulWidget {
  final DraggableScrollableController draggableController;

  const StoryMarkerMap({super.key, required this.draggableController});

  @override
  StoryMarkerMapState createState() => StoryMarkerMapState();
}

class StoryMarkerMapState extends ConsumerState<StoryMarkerMap> with WidgetsBindingObserver {
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
      ref.read(markerListProvider.notifier).fetchMarkers(mapController!, MediaQuery.of(context).size.height, _onMarkerTapped);
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
    widget.draggableController.animateTo(0.6, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    ref.read(selectedMarkerProvider.notifier).state = tappedMarker; // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _customNaverMap(),
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

  FocusDetector _customNaverMap() {
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
          onCameraChange: (_, __) {
            widget.draggableController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          onMapTapped: (_, __) {
            widget.draggableController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          options: const NaverMapViewOptions(
            liteModeEnable: true,
            initialCameraPosition: NCameraPosition(
              target: NLatLng(37.5, 127),
              zoom: 12,
            ),
          ),
        ));
  }
}
