import 'package:flutter/material.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_bottom_sheet.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_marker_map.dart';
import '../auth/custom_drawer.dart';
import '../../style/style.dart';

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
          elevation: 4,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
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
                // color: Colors.white,
              ),
              const SizedBox(width: 8),
            ],
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                // 지도 새로고침 기능
              },
              tooltip: '지도 새로고침',
            ),
          ],
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
