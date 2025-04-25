import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNaverMap();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    print('Firebase 초기화 실패: $e');
  }
}

Future<void> _initNaverMap() async {
  await dotenv.load(fileName: ".env.dev");
  final String xNcpApigwApiKeyId = dotenv.get("X_NCP_APIGW_API_KEY_ID");
  await FlutterNaverMap().init(clientId: xNcpApigwApiKeyId);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const WelcomePage(),
      routes: {
        '/home': (_) => const WelcomePage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
