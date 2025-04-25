import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:region_based_chat/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase 서비스 인스턴스
final markerServiceProvider = Provider((ref) => FirebaseFirestoreService(FirebaseFirestore.instance));

// 마커 리스트 상태 관리
final markerListProvider = StateNotifierProvider<MarkerListNotifier, List<Marker>>((ref) {
  final markerService = ref.watch(markerServiceProvider);
  return MarkerListNotifier(markerService);
});

// 선택된 마커 상태 관리
final selectedMarkerProvider = StateProvider<Marker?>((ref) => null);

// 마커 리스트 상태 관리용 Notifier
class MarkerListNotifier extends StateNotifier<List<Marker>> {
  final FirebaseFirestoreService firebaseFirestoreService;

  MarkerListNotifier(this.firebaseFirestoreService) : super([]);

  Future<void> fetchMarkers() async {
    log('featch markers');
    final markers = await firebaseFirestoreService.fetchMarkers();
    state = markers.map((doc) => Marker.fromFirestore(doc)).toList();
  }
}
