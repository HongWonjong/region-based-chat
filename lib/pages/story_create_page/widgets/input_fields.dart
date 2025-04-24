import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final Function(String)? onTitleChanged;
  final Function(String)? onContentChanged;

  const InputFields({
    super.key,
    required this.titleController,
    required this.contentController,
    this.onTitleChanged,
    this.onContentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: '제목을 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: onTitleChanged,
        ),
        SizedBox(height: 16),
        TextField(
          controller: contentController,
          maxLines: 12,
          decoration: InputDecoration(
            hintText: '내용을 입력하세요',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: onContentChanged,
        ),
      ],
    );
  }
}
