import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      final isSignedIn = await googleSignIn.isSignedIn();

      GoogleSignInAccount? googleUser;

      if (isSignedIn) {
        googleUser = await googleSignIn.signInSilently();
        print('기존 계정으로 자동 로그인 시도');
      } else {
        googleUser = await googleSignIn.signIn();
        print('로그인 창 표시됨');
      }

      if (googleUser == null) {
        print('사용자가 로그인을 취소했거나 실패함');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final currentUser = FirebaseAuth.instance.currentUser;
      state = FirebaseAuth.instance.currentUser;

      print('로그인 성공: ${state?.email}');

      /// 파이어스토어에 해당 uid 문서 있는지 확인
      final uid = currentUser!.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final nickname = doc.data()?['nickname'];

      if (doc.exists && nickname != null && nickname != "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/register');
      }
    } catch (e) {
      print("로그인 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 실패: \$e")),
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
    print('로그아웃 완료');
  }
}
