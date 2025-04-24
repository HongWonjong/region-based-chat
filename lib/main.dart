// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _initNaverMap();

//   try {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     runApp(const ProviderScope(child: MyApp()));
//   } catch (e) {
//     print('Firebase 초기화 실패: $e');
//   }
// }

// Future<void> _initNaverMap() async {
//   await dotenv.load(fileName: ".env.dev");
//   final String xNcpApigwApiKeyId = dotenv.get("X_NCP_APIGW_API_KEY_ID");
//   await FlutterNaverMap().init(clientId: xNcpApigwApiKeyId);
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
//       home: const WelcomePage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'pages/auth/custom_drawer.dart'; // Drawer 파일 경로에 맞게 수정

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env.dev 파일 로딩
  await dotenv.load(fileName: ".env.dev");

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("테스트 로그인")),
      drawer: const CustomDrawer(), // 로그인 드로어
      body: const Center(child: Text("메인 콘텐츠 (지도 등)")),
    );
  }
}
