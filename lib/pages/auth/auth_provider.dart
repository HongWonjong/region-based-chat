import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../welcome_page/welcome_page.dart';
import '../../providers/marker_provider.dart'; // 추가됨

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle(BuildContext context, WidgetRef ref) async {
    // ref 추가됨
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final isSignedIn = await googleSignIn.isSignedIn();
      GoogleSignInAccount? googleUser;

      if (isSignedIn) {
        googleUser = await googleSignIn.signInSilently();
        log('기존 계정으로 자동 로그인 시도');
      } else {
        googleUser = await googleSignIn.signIn();
        log('로그인 창 표시됨');
      }

      if (googleUser == null) {
        log('사용자가 로그인을 취소했거나 실패함');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      state = FirebaseAuth.instance.currentUser;

      log('로그인 성공: ${state?.email}');

      /// 파이어스토어에 해당 uid 문서 있는지 확인
      final uid = state!.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final nickname = doc.data()?['username'];

      if (doc.exists && nickname != null && nickname != "") {
        ref.invalidate(markerListProvider); // 보완됨
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/register');
      }
    } catch (e) {
      log("로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: $e")),
      );
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);
    try {
      await googleSignIn.disconnect(); // 세션 초기화
    } catch (_) {}
    await googleSignIn.signOut(); // 구글 계정 로그아웃
    await FirebaseAuth.instance.signOut(); // Firebase 로그아웃
    state = null;
    log('로그아웃 완료');
  }
}
