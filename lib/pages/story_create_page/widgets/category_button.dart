import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final Color? color;
  final Color? activeColor;
  final String text;
  final bool initiallySelected;
  final Function(bool)? onSelectionChanged;

  const CategoryButton({
    super.key,
    this.color,
    this.activeColor,
    this.text = '소문 카테고리',
    this.initiallySelected = false,
    this.onSelectionChanged,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initiallySelected;
  }

  @override
  void didUpdateWidget(CategoryButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallySelected != widget.initiallySelected) {
      _isSelected = widget.initiallySelected;
    }
  }

  void _handleTap() {
    if (!_isSelected && widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: _handleTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isSelected
                ? widget.activeColor
                : (widget.color ?? Colors.grey),
            foregroundColor: Colors.black,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: _isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            widget.text,
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
