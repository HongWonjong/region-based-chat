import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        _imageFiles = selectedImages;
      });
    }
  }

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
            selectImage(),
            input(),
            Spacer(),
            Row(
              children: [
                categoreButton(text: '일반적인 행사'),
                SizedBox(width: 10),
                categoreButton(color: Color(0xFF77FA7D), text: '가벼운사건'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                categoreButton(text: '중요한 사건/범죄'),
                SizedBox(width: 10),
                categoreButton(text: '분실'),
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

  Container selectImage() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // 이미지 추가 버튼
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 32, color: Colors.grey[600]),
                  SizedBox(height: 8),
                  Text('사진 추가', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
          // 선택된 이미지 표시
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(_imageFiles[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFiles.removeAt(index);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.close, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded categoreButton({Color? color, String text = '소문 카테고리'}) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey,
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
