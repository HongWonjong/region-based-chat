import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/pages/auth/register_page.dart';
import 'package:region_based_chat/pages/welcome_page/welcome_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print('Firebase 초기화 실패: $e');
  }
  await _initNaverMap();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _initNaverMap() async {
  await dotenv.load(fileName: ".env.dev");
  final String xNcpApigwApiKeyId = dotenv.get("X_NCP_APIGW_API_KEY_ID");
  await FlutterNaverMap().init(clientId: xNcpApigwApiKeyId);
}

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      home: const WelcomePage(),
      routes: {
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}

// 테마 토글 위젯 예시 (원하는 곳에 배치)
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return IconButton(
      icon: Icon(
        themeMode == ThemeMode.dark
            ? Icons.dark_mode
            : themeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.brightness_auto,
      ),
      tooltip: '다크모드 전환',
      onPressed: () {
        ref.read(themeModeProvider.notifier).state =
            themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
    );
  }
}
