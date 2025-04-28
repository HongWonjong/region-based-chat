import 'package:flutter/material.dart';
import 'widget/story_bottom_sheet.dart';
import 'widget/story_marker_map.dart';
import '../auth/custom_drawer.dart';
import '../../style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../story_create_page/story_create_page.dart';
import '../../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final DraggableScrollableController draggableController =
      DraggableScrollableController();

  bool isBottomSheetOpen = false;
  bool isMarkerTapped = false;

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          flexibleSpace: Container(
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
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_soeasy.png',
                height: 110,
              ),
              const SizedBox(width: 8),
            ],
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.white),
              onPressed: () {
                // 스토리 작성 페이지로 이동
                if (isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StoryCreatePage(),
                    ),
                  );
                }
              },
              tooltip: '소문 작성하기',
            )
          ],
        ),
        drawer: const CustomDrawer(), // 로그인 드로어,
        body: Stack(
          children: [
            StoryMarkerMap(draggableController: draggableController),
            StoryBottomSheet(draggableController: draggableController)
          ],
        ));
  }
}
