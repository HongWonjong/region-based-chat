import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageButton extends StatefulWidget {
  final Function(List<XFile>)? onImagesSelected;

  const SelectImageButton({
    super.key,
    this.onImagesSelected,
  });

  @override
  State<SelectImageButton> createState() => _SelectImageButtonState();
}

class _SelectImageButtonState extends State<SelectImageButton> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  bool _isExpanded = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // 이미지 품질 조정
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(pickedFile);
          _isExpanded = true;
        });

        if (widget.onImagesSelected != null) {
          widget.onImagesSelected!(_selectedImages);
        }
      }
    } catch (e) {
      // 이미지 선택 오류 처리
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      if (_selectedImages.isEmpty) {
        _isExpanded = false;
      }
    });

    if (widget.onImagesSelected != null) {
      widget.onImagesSelected!(_selectedImages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 사진 선택 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 카메라로 촬영 버튼
            _buildSelectButton(
              icon: Icons.camera_alt,
              label: '사진 촬영',
              color: Colors.deepPurple.shade500,
              onTap: () => _pickImage(ImageSource.camera),
            ),

            // 갤러리에서 선택 버튼
            _buildSelectButton(
              icon: Icons.photo_library,
              label: '갤러리에서 선택',
              color: Colors.deepPurple.shade700,
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),

        // 선택된 이미지가 있을 경우 표시
        if (_selectedImages.isNotEmpty) ...[
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '선택된 사진 ${_selectedImages.length}장',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: Colors.deepPurple,
                ),
                label: Text(
                  _isExpanded ? '접기' : '펼치기',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(0, 0),
                ),
              ),
            ],
          ),

          // 선택된 이미지 그리드
          if (_isExpanded) ...[
            SizedBox(height: 12),
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return _buildImageThumbnail(index);
                },
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildSelectButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 36,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.deepPurple.shade100, width: 2),
            image: DecorationImage(
              image: FileImage(File(_selectedImages[index].path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: InkWell(
            onTap: () => _removeImage(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: Colors.deepPurple,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
