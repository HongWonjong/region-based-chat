// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user == null
                ? ElevatedButton(
                    onPressed: () => auth.signInWithGoogle(),
                    child: const Text("Sign in with Google"),
                  )
                : Text("환영합니다\n\${user.email}님"),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("소문내기"),
              onTap: () {},
            ),
            if (user != null)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("로그아웃"),
                onTap: () => auth.signOut(),
              ),
          ],
        ),
      ),
    );
  }
}
