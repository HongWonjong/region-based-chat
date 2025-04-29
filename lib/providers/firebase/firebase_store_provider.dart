import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/marker_repository.dart';
import '../../services/firebase/firebase_firestore_service.dart';

// FirebaseFirestoreService를 Provider로 등록
final firebaseStoreServiceProvider = Provider<FirebaseFirestoreService>((ref) {
  return FirebaseFirestoreService(FirebaseFirestore.instance); // 실제 인스턴스 생성
});

// MarkerRepository를 Provider로 등록
final markerRepositoryProvider = Provider<MarkerRepository>((ref) {
  final firebaseFirestoreService = ref.watch(firebaseStoreServiceProvider); // firebaseFirestoreService를 주입받음
  return MarkerRepository(firebaseFirestoreService);
});
