import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  const InputFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: '제목을 입력하세요',
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
}
