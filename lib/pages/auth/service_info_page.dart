import 'package:flutter/material.dart';

class ServiceIntroPage extends StatelessWidget {
  const ServiceIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('소이지 서비스 소개 ✨'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📢 소이지란?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '소이지는 소문 이웃 지킴이 라는 뜻을 가지고 있습니다.\n 내 주변 소식을 지도에서 바로 확인하고, 이웃들과 채팅까지 할 수 있는 신개념 플랫폼이에요! 🗺️💬\n\n'
              '길거리에서 본 이상한 사건, 동네 행사 소식 등 빠르게 공유하고 싶을 때, 소이지가 딱! 🧡',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '✨ 주요 기능',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '📍 내 위치에 핀 찍기: 사건/이벤트를 지도에 바로 등록!\n'
              '💬 실시간 대화: 같은 핀(마커) 사람들과 바로 채팅!\n'
              '🧑‍🎨 내 프로필 꾸미기: 프로필 이미지로 나를 표현해요!\n'
              '🚀 초고속 서버: Firebase로 빠르고 안전한 연결!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '🔥 이런 분들에게 추천!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '• 동네 소식이 궁금한 분\n'
              '• 이웃들과 소통하고 싶은 분\n'
              '• 빠르게 사건을 공유하고 싶은 분\n'
              '• 지역 커뮤니티를 만들고 싶은 분\n\n'
              '소이지와 함께, 이웃이 더 가까워집니다! 🏡💖',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
