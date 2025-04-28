import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:region_based_chat/pages/auth/widgets/google_sign_in_button.dart';
import 'package:region_based_chat/pages/auth/widgets/show_register_prompt.dart';
import 'package:region_based_chat/pages/story_create_page/story_create_page.dart';
import 'auth_provider.dart';
import 'dart:io';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  // 이미지 선택 및 업로드
  Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authProvider);
    if (user == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        await ref.read(authProvider.notifier).uploadProfileImage(pickedFile);
        // 업로드 후 UI 갱신을 위해 authProvider 무효화
        ref.invalidate(authProvider);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지 업로드 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final auth = ref.read(authProvider.notifier);

    return Drawer(
      child: Container(
        color: const Color(0xFFF7F2FA),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              user == null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "기능을 사용하시려면 \n로그인 해 주세요",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  GoogleSignInButton(
                    onPressed: () => auth.signInWithGoogle(context),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 이미지
                  GestureDetector(
                    onTap: () => _pickAndUploadImage(context, ref),
                    child: FutureBuilder<String?>(
                      future: auth.getProfileImageUrl(),
                      builder: (context, snapshot) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundImage: snapshot.hasData
                              ? NetworkImage(snapshot.data!)
                              : null,
                          child: snapshot.hasData
                              ? null
                              : const Icon(Icons.person, size: 40),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "환영합니다\n${user.email}님",
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (user != null)
                GestureDetector(
                  child: ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("소문내기"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoryCreatePage(),
                        ),
                      );
                    },
                  ),
                ),
              const Divider(),
              const SizedBox(height: 20),
              if (user != null)
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("로그아웃"),
                  onTap: () => ref.read(authProvider.notifier).signOut(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}