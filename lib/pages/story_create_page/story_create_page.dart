import 'package:flutter/material.dart';
import 'widgets/select_image_button.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_button.dart';

class StoryCreatePage extends StatelessWidget {
  const StoryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('소문내기',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectImageButton(),
            InputFields(),
            Spacer(),
            Row(
              children: [
                CategoryButton(text: '일반적인 행사'),
                SizedBox(width: 10),
                CategoryButton(
                  color: Color(0xFF77FA7D),
                  text: '가벼운사건',
                  isSelected: true,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CategoryButton(text: '중요한 사건/범죄'),
                SizedBox(width: 10),
                CategoryButton(text: '분실'),
              ],
            ),
            Spacer(),
            SubmitButton(),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
