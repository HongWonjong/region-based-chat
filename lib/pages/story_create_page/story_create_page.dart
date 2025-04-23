import 'package:flutter/material.dart';
import 'widgets/select_image_button.dart';

class StoryCreatePage extends StatelessWidget {
  const StoryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '소문내기',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectImageButton(),
            input(),
            Spacer(),
            Row(
              children: [
                categoryButton(text: '일반적인 행사'),
                SizedBox(width: 10),
                categoryButton(
                    color: Color(0xFF77FA7D), text: '가벼운사건', isSelected: true),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                categoryButton(text: '중요한 사건/범죄'),
                SizedBox(width: 10),
                categoryButton(text: '분실'),
              ],
            ),
            Spacer(),
            submitButton(),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  Column input() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: '내용을 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            contentPadding: EdgeInsets.all(16),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          maxLines: 12,
          decoration: InputDecoration(
            hintText: '내용을 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  SizedBox submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.blue.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: Text(
          '소문내기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Expanded categoryButton(
      {Color? color, String text = '소문 카테고리', bool isSelected = false}) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey, //TODO: 카테고리 선택 시 색상 변경
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

SizedBox submitButton() {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.blue.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
      child: Text(
        '소문내기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
