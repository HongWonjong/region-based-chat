import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  // 환경변수에서 clientId 가져와서 GoogleSignIn 객체 생성
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    scopes: ['email'],
  );

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      state = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("로그인 실패: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect(); // 내부 세션까지 초기화
    await googleSignIn.signOut();

    state = null;
  }
}
