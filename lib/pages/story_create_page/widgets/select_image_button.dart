import 'dart:developer';
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

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85, // 이미지 품질 조정
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles);
          _isExpanded = true;
        });

        if (widget.onImagesSelected != null) {
          widget.onImagesSelected!(_selectedImages);
        }
      }
    } catch (e) {
      // 이미지 선택 오류 처리
      log('이미지 선택 오류: $e');
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 사진 선택 버튼
        Center(
          child: _buildSelectButton(
            icon: Icons.photo_library,
            label: '갤러리에서 여러 사진 선택',
            color: isDark ? Colors.amber : Colors.deepPurple.shade700,
            isDark: isDark,
            onTap: _pickMultipleImages,
          ),
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
                  color: isDark ? Colors.amber[200] : Colors.deepPurple.shade800,
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
                  color: isDark ? Colors.amber : Colors.deepPurple,
                ),
                label: Text(
                  _isExpanded ? '접기' : '펼치기',
                  style: TextStyle(
                    color: isDark ? Colors.amber : Colors.deepPurple,
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
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return _buildImageThumbnail(index, isDark);
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
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? color.withOpacity(0.5) : color.withOpacity(0.2),
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

  Widget _buildImageThumbnail(int index, bool isDark) {
    final borderColor = isDark ? Colors.amber.withOpacity(0.5) : Colors.deepPurple.shade100;
    final closeIconColor = isDark ? Colors.amber : Colors.deepPurple;
    final closeBackgroundColor = isDark ? Colors.grey[800] : Colors.white;

    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 2),
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
                color: closeBackgroundColor,
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
                color: closeIconColor,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
