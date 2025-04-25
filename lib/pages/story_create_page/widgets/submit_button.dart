import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const SubmitButton({
    super.key,
    this.onPressed,
    this.text = '소문내기',
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.deepPurple : Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: isEnabled ? 2 : 0,
          shadowColor: isEnabled ? Colors.blue.shade200 : Colors.transparent,
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
    );
  }
}
