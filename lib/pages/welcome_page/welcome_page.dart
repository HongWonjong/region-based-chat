import 'package:flutter/material.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_bottom_sheet.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_marker_map.dart';

import '../auth/custom_drawer.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const CustomDrawer(), // 로그인 드로어
        body: Stack(
          children: [StoryMarkerMap(), StoryBottomSheet()],
        ));
  }
}
