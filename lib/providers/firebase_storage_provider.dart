import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/services/firebase_storage.dart';

// FirebaseStorageServiceProvider Provider로 등록
final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService(FirebaseStorage.instance); // 실제 인스턴스 생성
});
