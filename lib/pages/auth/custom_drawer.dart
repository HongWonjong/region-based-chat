import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'service_info_page.dart';
import 'widgets/google_sign_in_button.dart';
import '../story_create_page/story_create_page.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';
import 'dart:io';
import '../../style/style.dart';
import '../../main.dart';

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
        await ref
            .read(profileProvider(user.uid).notifier)
            .uploadProfileImage(pickedFile);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('프로필 이미지 업로드 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider);
    final profileState =
        user != null ? ref.watch(profileProvider(user.uid)) : null;
    final profileImageUrl = profileState?.profileImageUrl;
    final username = profileState?.username;

    return Drawer(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          // 헤더 부분
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black,
                        Colors.grey[850]!,
                      ]
                    : [
                        AppBarStyles.appBarGradientStart,
                        AppBarStyles.appBarGradientEnd,
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 프로필 이미지 및 정보
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // 프로필 이미지
                        GestureDetector(
                          onTap: user != null
                              ? () => _pickAndUploadImage(context, ref)
                              : null,
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? Colors.grey[800] : Colors.white,
                              border: Border.all(
                                color:
                                    isDark ? Colors.grey[700]! : Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: profileImageUrl != null
                                  ? Image.network(
                                      profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.person,
                                        size: 40,
                                        color: isDark
                                            ? Colors.amber
                                            : Colors.deepPurple,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 40,
                                      color: isDark
                                          ? Colors.amber
                                          : Colors.deepPurple,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 사용자 닉네임
                              Text(
                                user == null
                                    ? "게스트"
                                    : username ?? user.displayName ?? "사용자",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user == null ? "로그인 필요" : user.email ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 로그인 버튼 (로그인하지 않은 경우에만 표시)
                  if (user == null)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 20, right: 20),
                      child: GoogleSignInButton(
                        onPressed: () => ref
                            .read(authProvider.notifier)
                            .signInWithGoogle(context),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 테마 전환 버튼
          Container(
            color: isDark ? Colors.grey[850] : const Color(0xFFF7F2FA),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "다크모드",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Switch(
                    value: isDark,
                    activeColor: Colors.amber,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).state =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),
          ),

          // 메뉴 항목들
          Expanded(
            child: Container(
              color: isDark ? Colors.grey[850] : const Color(0xFFF7F2FA),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 소문내기 메뉴
                    if (user != null)
                      _buildMenuItem(
                        icon: Icons.edit_note,
                        title: "소문내기",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoryCreatePage(),
                            ),
                          );
                        },
                        isDark: isDark,
                      ),

                    // 메뉴 구분선
                    Divider(
                      height: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),

                    // 서비스 소개 메뉴
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: "서비스 소개",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceIntroPage(),
                          ),
                        );
                      },
                      isDark: isDark,
                    ),

                    // 메뉴 구분선
                    Divider(
                      height: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),

                    // 로그아웃 메뉴 (로그인한 경우만)
                    if (user != null)
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: "로그아웃",
                        iconColor: Colors.redAccent,
                        textColor: Colors.redAccent,
                        onTap: () async {
                          await ref.read(authProvider.notifier).signOut();
                          // 로그아웃 시 profileProvider 초기화
                          if (user.uid != null) {
                            ref.invalidate(profileProvider(user.uid));
                          }
                        },
                        isDark: isDark,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 하단 앱 버전 정보
          Container(
            width: double.infinity,
            color: isDark ? Colors.grey[850] : const Color(0xFFF7F2FA),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Text(
                  "앱 버전 1.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 메뉴 아이템 위젯
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.deepPurple,
    Color textColor = Colors.black87,
    bool isDark = false,
  }) {
    // 다크모드일 때 기본 색상 변경 (빨간색 같은 특수 색상은 그대로 유지)
    if (isDark && iconColor == Colors.deepPurple) {
      iconColor = Colors.amber;
    }
    if (isDark && textColor == Colors.black87) {
      textColor = Colors.white;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor:
            isDark ? Colors.grey[700] : Colors.deepPurple.withOpacity(0.1),
        highlightColor:
            isDark ? Colors.grey[800] : Colors.deepPurple.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 24),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
