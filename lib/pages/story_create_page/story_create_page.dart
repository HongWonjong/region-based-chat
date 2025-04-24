import 'package:flutter/material.dart';
import 'widgets/select_image_button.dart';
import 'widgets/input_fields.dart';
import 'widgets/submit_button.dart';
import 'widgets/category_button.dart';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  int _selectedCategoryIndex = 1; // 기본값: '가벼운사건'

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectImageButton(),
              InputFields(),
              Spacer(),
              Row(
                children: [
                  CategoryButton(
                    text: '일반적인 행사',
                    color: Colors.grey[300],
                    activeColor: Color(0xffEEFF06).withAlpha(76),
                    initiallySelected: _selectedCategoryIndex == 0,
                    onSelectionChanged: (_) => _selectCategory(0),
                  ),
                  SizedBox(width: 10),
                  CategoryButton(
                    color: Colors.grey[300],
                    activeColor: Color(0xFF77FA7D).withAlpha(76),
                    text: '가벼운사건',
                    initiallySelected: _selectedCategoryIndex == 1,
                    onSelectionChanged: (_) => _selectCategory(1),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  CategoryButton(
                    text: '중요한 사건/범죄',
                    color: Colors.grey[300],
                    activeColor: Color(0xffF20C0C).withAlpha(76),
                    initiallySelected: _selectedCategoryIndex == 2,
                    onSelectionChanged: (_) => _selectCategory(2),
                  ),
                  SizedBox(width: 10),
                  CategoryButton(
                    text: '분실',
                    color: Colors.grey[300],
                    activeColor: Color(0xff0022FF).withAlpha(76),
                    initiallySelected: _selectedCategoryIndex == 3,
                    onSelectionChanged: (_) => _selectCategory(3),
                  ),
                ],
              ),
              Spacer(),
              SubmitButton(),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
