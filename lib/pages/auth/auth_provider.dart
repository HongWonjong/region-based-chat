import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: dotenv.env['GOOGLE_CLIENT_ID'],
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
      state = FirebaseAuth.instance.currentUser;

      print('로그인 성공: ${state?.email}');
    } catch (e) {
      print("로그인 실패: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    final googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
      scopes: ['email'],
    );

    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    state = null;
    print('로그아웃 완료');
  }
}
