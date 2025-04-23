import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Color? color;
  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;

  const CategoryButton({
    super.key,
    this.color,
    this.text = '소문 카테고리',
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey,
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
