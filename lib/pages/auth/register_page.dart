import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';

final nicknameProvider = StateProvider<String>((ref) => '');
final isRegisteringProvider = StateProvider<bool>((ref) => false);
final profileImageProvider = StateProvider<XFile?>((ref) => null);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final nickname = ref.read(nicknameProvider).trim();

    // 닉네임 유효성 검사
    final validNickname = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣]+$');

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임을 입력해주세요.")),
      );
      return;
    }

    if (nickname.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임은 10자 이하로 입력해주세요.")),
      );
      return;
    }

    if (!validNickname.hasMatch(nickname)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("닉네임은 특수문자를 제외하고 입력해주세요.")),
      );
      return;
    }

    ref.read(isRegisteringProvider.notifier).state = true;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final email = user.email;

    String profileImageUrl = "";
    final pickedFile = ref.read(profileImageProvider);

    ///스토리지 연결 전이라 이미지 선택시 오류날수 있음 스토리지 연결되면 정상작동
    if (pickedFile != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('users/profileImages/\$uid.jpg');
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
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
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
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
            const SizedBox(height: 12),
            TextField(
              maxLength: 10,
              onChanged: (value) =>
                  ref.read(nicknameProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: '예: 피터개발자',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ref),
                  child: const Text('프로필 이미지 선택'),
                ),
                const SizedBox(width: 12),
                if (profileImage != null)
                  CircleAvatar(
                    backgroundImage: FileImage(File(profileImage.path)),
                    radius: 30,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _submit(context, ref),
                      child: const Text('등록하기'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
