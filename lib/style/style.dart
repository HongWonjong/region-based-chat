import 'package:flutter/material.dart';

// 앱바 관련 스타일
class AppBarStyles {
  static const Color appBarBackgroundColor = Colors.deepPurple;
  static const Color appBarGradientStart = Colors.deepPurple;
  static const Color appBarGradientEnd = Color(0xFF7E57C2);
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.white,
  );
}

// 배경 색상
class BackgroundStyles {
  static const Color chatBackgroundColor = Colors.white;
}

// 버튼 관련 스타일
class ButtonStyles {
  static const Color buttonBackgroundColor = Colors.deepPurple;
  static const Color buttonIconColor = Colors.white;
  static const Color imageButtonBackgroundColor = Colors.deepPurple;
  static const double buttonElevation = 5.0;
  static const EdgeInsets buttonPadding = EdgeInsets.all(12);
}

// 메시지 카드 스타일
class MessageCardStyles {
  static const Color myMessageColor = Colors.blue;
  static const Color otherMessageColor = Colors.white;
  static const BorderRadius messageBorderRadius = BorderRadius.all(Radius.circular(12));
  static const EdgeInsets messagePadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const BoxShadow messageShadow = BoxShadow(
    color: Colors.black12,
    spreadRadius: 1,
    blurRadius: 6,
    offset: Offset(0, 3),
  );
}

// 텍스트 필드 스타일
class TextFieldStyles {
  static const Color textFieldBackgroundColor = Colors.white;
  static const Color textFieldFillColor = Color(0xFFF5F5F5);
  static const BorderRadius textFieldBorderRadius = BorderRadius.all(Radius.circular(20));
  static const EdgeInsets textFieldPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const BoxShadow textFieldShadow = BoxShadow(
    color: Colors.black12,
    spreadRadius: 1,
    blurRadius: 6,
    offset: Offset(0, 3),
  );
}