import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onConfirm;
  final String confirmText;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.color,
    this.icon,
    this.onConfirm,
    this.confirmText = '확인',
  });

  // 성공 알림창
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmText = '확인',
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogWithAnimation(
        child: CustomAlertDialog(
          title: title,
          message: message,
          color: Colors.green,
          icon: Icons.check_circle,
          onConfirm: onConfirm,
          confirmText: confirmText,
        ),
      ),
    );
  }

  // 오류 알림창
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onConfirm,
    String confirmText = '확인',
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DialogWithAnimation(
        child: CustomAlertDialog(
          title: title,
          message: message,
          color: Colors.red,
          icon: Icons.error,
          onConfirm: onConfirm,
          confirmText: confirmText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color dialogColor = color ?? theme.primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: dialogColor.withAlpha(50),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dialogColor.withAlpha(30),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: dialogColor,
                      size: 28,
                    ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 메시지
            Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF555555),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // 확인 버튼
            Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) {
                      onConfirm!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dialogColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    confirmText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 애니메이션을 위한 스테이트풀 위젯
class _DialogWithAnimation extends StatefulWidget {
  final Widget child;

  const _DialogWithAnimation({required this.child});

  @override
  State<_DialogWithAnimation> createState() => _DialogWithAnimationState();
}

class _DialogWithAnimationState extends State<_DialogWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
