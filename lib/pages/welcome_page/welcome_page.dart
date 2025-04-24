import 'package:flutter/material.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_bottom_sheet.dart';
import 'package:region_based_chat/pages/welcome_page/widget/story_marker_map.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [StoryMarkerMap(), StoryBottomSheet()],
        ));
  }
}
