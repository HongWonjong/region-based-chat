import 'package:flutter/material.dart';

class StoryCreatePage extends StatelessWidget {
  const StoryCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '소문내기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '내용을 입력하세요',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 11,
              decoration: InputDecoration(
                hintText: '내용을 입력하세요',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            Spacer(),
            SizedBox(
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
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}
