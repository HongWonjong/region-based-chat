import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final nicknameProvider = StateProvider<String>((ref) => '');
final isRegisteringProvider = StateProvider<bool>((ref) => false);
final profileImageProvider = StateProvider<XFile?>((ref) => null);

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final nickname = ref.read(nicknameProvider).trim();
    if (nickname.isEmpty) return;

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
      'nickname': nickname,
      'profileImage': profileImageUrl,
      'createdAt': Timestamp.now(),
      'lastLoginAt': Timestamp.now(),
    });

    ref.read(isRegisteringProvider.notifier).state = false;
    Navigator.pushReplacementNamed(context, '/home');
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
            const Text('닉네임을 입력해주세요'),
            TextField(
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => _submit(context, ref),
                    child: const Text('등록하기'),
                  )
          ],
        ),
      ),
    );
  }
}
