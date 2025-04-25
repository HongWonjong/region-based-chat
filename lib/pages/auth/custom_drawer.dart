import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/pages/auth/widgets/google_sign_in_button.dart';
import 'package:region_based_chat/pages/auth/widgets/show_register_prompt.dart';
import 'package:region_based_chat/pages/story_create_page/story_create_page.dart';
import 'auth_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

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
                        const Text("기능을 사용하시려면 \n로그인 해 주세요",
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        const SizedBox(height: 8),
                        GoogleSignInButton(
                          onPressed: () => auth.signInWithGoogle(context),
                        ),
                      ],
                    )
                  : Text("환영합니다\n${user.email}님",
                      style: TextStyle(
                        fontSize: 17,
                      )),
              user != null
                  ? GestureDetector(
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
                    )
                  : const SizedBox.shrink(), // 로그인 안 된 경우 아무것도 안 보임
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
