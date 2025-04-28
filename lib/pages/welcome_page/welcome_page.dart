import 'package:flutter/material.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_bottom_sheet.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_marker_map.dart';
import '../auth/custom_drawer.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo_soeasy.png', // 네 로고 이미지 경로
            height: 110,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        drawer: const CustomDrawer(), // 로그인 드로어
        body: Stack(
          children: [
            StoryMarkerMap(draggableController: draggableController),
            StoryBottomSheet(draggableController: draggableController)
          ],
        ));
  }
}
