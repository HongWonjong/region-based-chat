import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:region_based_chat/firebase_options.dart';
import 'package:region_based_chat/pages/auth/custom_drawer.dart';

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
