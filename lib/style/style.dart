import 'package:flutter/material.dart';

// 앱바 관련 스타일
class AppBarStyles {
  static const Color appBarBackgroundColor = Color(0xFF6A1B9A);
  static const Color appBarGradientStart = Color(0xFF8E24AA);
  static const Color appBarGradientEnd = Color(0xFF5E35B1);
  static const TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 0.5,
  );
  static const IconThemeData appBarIconTheme = IconThemeData(
    color: Colors.white,
    size: 24,
  );
}

// 배경 색상
class BackgroundStyles {
  static const Color chatBackgroundColor = Color(0xFFF5F5F5);
  static const DecorationImage chatBackgroundImage = DecorationImage(
    image: AssetImage('assets/chat_background.png'),
    fit: BoxFit.cover,
    opacity: 0.08,
  );
}

// 버튼 관련 스타일
class ButtonStyles {
  static const Color buttonBackgroundColor = Color(0xFF7B1FA2);
  static const Color buttonIconColor = Colors.white;
  static const Color imageButtonBackgroundColor = Color(0xFFAB47BC);
  static const double buttonElevation = 3.0;
  static const EdgeInsets buttonPadding = EdgeInsets.all(14);
  static final BoxDecoration sendButtonDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF7B1FA2).withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
}

// 메시지 카드 스타일
class MessageCardStyles {
  static const Color myMessageColor = Color(0xFFE1BEE7);
  static const Color myTextColor = Color(0xFF4A148C);
  static const Color otherMessageColor = Colors.white;
  static const Color otherTextColor = Color(0xFF212121);

  static final BorderRadius myMessageBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(15),
    topRight: Radius.circular(15),
    bottomLeft: Radius.circular(15),
    bottomRight: Radius.circular(5),
  );

  static final BorderRadius otherMessageBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(15),
    topRight: Radius.circular(15),
    bottomLeft: Radius.circular(5),
    bottomRight: Radius.circular(15),
  );

  static const EdgeInsets messagePadding =
      EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  static const BoxShadow messageShadow = BoxShadow(
    color: Colors.black12,
    spreadRadius: 0.5,
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const TextStyle timeTextStyle = TextStyle(
    fontSize: 10,
    color: Color(0xFF9E9E9E),
    fontWeight: FontWeight.w400,
  );

  static const TextStyle senderNameStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Color(0xFF4A148C),
    letterSpacing: 0.3,
  );
}

// 텍스트 필드 스타일
class TextFieldStyles {
  static const Color textFieldBackgroundColor = Colors.white;
  static const Color textFieldFillColor = Colors.white;
  static final BorderRadius textFieldBorderRadius =
      BorderRadius.all(Radius.circular(25));
  static const EdgeInsets textFieldPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static const BoxShadow textFieldShadow = BoxShadow(
    color: Colors.black12,
    spreadRadius: 0.5,
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  static final InputDecoration textFieldDecoration = InputDecoration(
    hintText: '메시지를 입력하세요...',
    hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: textFieldBorderRadius,
      borderSide: BorderSide.none,
    ),
    contentPadding: textFieldPadding,
    filled: true,
    fillColor: textFieldFillColor,
    enabledBorder: OutlineInputBorder(
      borderRadius: textFieldBorderRadius,
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: textFieldBorderRadius,
      borderSide: BorderSide(color: Color(0xFF9C27B0), width: 1.5),
    ),
  );
}
