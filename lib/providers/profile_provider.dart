import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ProfileState 클래스 정의
class ProfileState {
  final String? profileImageUrl;
  final String? username;

  ProfileState({this.profileImageUrl, this.username});
}

// profileProvider 정의
final profileProvider = StateNotifierProvider.family<ProfileNotifier, ProfileState, String?>(
  (ref, uid) => ProfileNotifier(uid),
);

class ProfileNotifier extends StateNotifier<ProfileState> {
  final String? uid;

  ProfileNotifier(this.uid) : super(ProfileState()) {
    if (uid != null) {
      _loadProfile();
    }
  }

  // Firestore에서 프로필 정보 로드
  Future<void> _loadProfile() async {
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final url = doc.data()?['profileImageUrl'] as String?;
      final username = doc.data()?['username'] as String?;

      state = ProfileState(
        profileImageUrl: url,
        username: username,
      );
    } catch (e) {
      log('프로필 정보 로드 실패: $e');
      state = ProfileState(profileImageUrl: null, username: null);
    }
  }

  // 프로필 이미지 업로드
  Future<void> uploadProfileImage(XFile image) async {
    if (uid == null) return;

    try {
      final ref = FirebaseStorage.instance.ref().child('users/profileImages/$uid.jpg');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      // Firestore에 프로필 이미지 URL 저장
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'profileImageUrl': url});

      // 상태 업데이트
      state = ProfileState(profileImageUrl: url, username: state.username);
    } catch (e) {
      log('프로필 이미지 업로드 실패: $e');
      throw Exception('프로필 이미지 업로드 실패: $e');
    }
  }
}
