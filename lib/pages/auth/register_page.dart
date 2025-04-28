import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';
import 'package:region_based_chat/providers/marker_provider.dart';
import 'package:region_based_chat/style/style.dart';

final nicknameProvider = StateProvider<String>((ref) => '');
final isRegisteringProvider = StateProvider<bool>((ref) => false);
final profileImageProvider = StateProvider<XFile?>((ref) => null);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final nickname = ref.read(nicknameProvider).trim();
    final validNickname = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+$');

    if (nickname.isEmpty) {
      _showSnackBar(context, "닉네임을 입력해주세요.");
      return;
    }

    if (nickname.length > 10) {
      _showSnackBar(context, "닉네임은 10자 이하로 입력해주세요.");
      return;
    }

    if (!validNickname.hasMatch(nickname)) {
      _showSnackBar(context, "닉네임은 특수문자를 제외하고 입력해주세요.");
      return;
    }

    final docs = (await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: nickname)
            .limit(1)
            .get())
        .docs;

    if (docs.isNotEmpty) {
      _showSnackBar(context, "이미 사용중인 닉네임입니다. 다른 닉네임을 입력해주세요.");
      return;
    }

    ref.read(isRegisteringProvider.notifier).state = true;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final email = user.email;

    String profileImageUrl = "";
    final pickedFile = ref.read(profileImageProvider);

    if (pickedFile != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('users/profileImages/$uid.jpg');
      await storageRef.putFile(File(pickedFile.path));
      profileImageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'username': nickname,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.now(),
      'lastLogin': Timestamp.now(),
      'joinedMarkers': [],
      'uid': uid,
    });

    ref.read(isRegisteringProvider.notifier).state = false;
    ref.invalidate(markerListProvider);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      ref.read(profileImageProvider.notifier).state = picked;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(nicknameProvider);
    final isLoading = ref.watch(isRegisteringProvider);
    final profileImage = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarStyles.appBarBackgroundColor,
        title: const Text('회원가입', style: AppBarStyles.appBarTitleStyle),
        iconTheme: AppBarStyles.appBarIconTheme,
      ),
      backgroundColor: BackgroundStyles.chatBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                '닉네임을 입력해주세요',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLength: 10,
              onChanged: (value) =>
                  ref.read(nicknameProvider.notifier).state = value,
              decoration: TextFieldStyles.textFieldDecoration.copyWith(
                hintText: '예: 피터개발자',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ButtonStyles.imageButtonBackgroundColor,
                      padding: ButtonStyles.buttonPadding,
                      elevation: ButtonStyles.buttonElevation,
                    ),
                    onPressed: () => _pickImage(ref),
                    child: const Text('프로필 이미지 선택',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                if (profileImage != null)
                  CircleAvatar(
                    backgroundImage: FileImage(File(profileImage.path)),
                    radius: 30,
                  ),
              ],
            ),
            const SizedBox(height: 36),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: ButtonStyles.buttonPadding,
                        backgroundColor: ButtonStyles.buttonBackgroundColor,
                        elevation: ButtonStyles.buttonElevation,
                      ),
                      onPressed: () => _submit(context, ref),
                      child: const Text('등록하기',
                          style: TextStyle(color: Colors.white)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
