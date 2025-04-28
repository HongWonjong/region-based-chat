import 'package:flutter/material.dart';

class ServiceIntroPage extends StatelessWidget {
  const ServiceIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: CustomScrollView(
        slivers: [
          // 애니메이션 효과가 있는 앱바
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? Colors.black : Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '소이지',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 그라데이션 배경
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                Colors.black,
                                Colors.grey[850]!,
                              ]
                            : [
                                Colors.deepPurple.shade800,
                                Colors.deepPurple.shade500,
                              ],
                      ),
                    ),
                  ),
                  // 원형 장식 패턴
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // 앱 로고 또는 아이콘 (메가폰)
                  Center(
                    child: Icon(
                      Icons.campaign,
                      size: 80,
                      color: isDark ? Colors.amber : Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 메인 콘텐츠
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),

                  // 소이지란?
                  _buildSectionTitle('소이지란?', Icons.bubble_chart, isDark),
                  SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '소이지는 소문 이웃 지킴이 라는 뜻을 가지고 있습니다.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.amber[200]
                                : Colors.deepPurple.shade800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '내 주변 소식을 지도에서 바로 확인하고, 이웃들과 채팅까지 할 수 있는 신개념 플랫폼이에요! 🗺️💬\n\n'
                          '길거리에서 본 이상한 사건, 동네 행사 소식 등 빠르게 공유하고 싶을 때, 소이지가 딱! 🧡',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    isDark: isDark,
                  ),

                  SizedBox(height: 30),

                  // 주요 기능
                  _buildSectionTitle('주요 기능', Icons.stars, isDark),
                  SizedBox(height: 16),

                  // 기능 카드 1
                  _buildFeatureCard(
                    icon: Icons.location_on,
                    color: Colors.redAccent,
                    title: '내 위치에 핀 찍기',
                    description: '사건/이벤트를 지도에 바로 등록하세요!',
                    isDark: isDark,
                  ),
                  SizedBox(height: 15),

                  // 기능 카드 2
                  _buildFeatureCard(
                    icon: Icons.chat_bubble,
                    color: Colors.blueAccent,
                    title: '실시간 대화',
                    description: '같은 핀(마커) 사람들과 바로 채팅하세요!',
                    isDark: isDark,
                  ),
                  SizedBox(height: 15),

                  // 기능 카드 3
                  _buildFeatureCard(
                    icon: Icons.person,
                    color: isDark
                        ? Colors.greenAccent
                        : Colors.greenAccent.shade700,
                    title: '내 프로필 꾸미기',
                    description: '프로필 이미지로 나를 표현해요!',
                    isDark: isDark,
                  ),
                  SizedBox(height: 15),

                  // 기능 카드 4
                  _buildFeatureCard(
                    icon: Icons.speed,
                    color: Colors.orangeAccent,
                    title: '초고속 서버',
                    description: 'Firebase로 빠르고 안전한 연결!',
                    isDark: isDark,
                  ),

                  SizedBox(height: 30),

                  // 추천 대상
                  _buildSectionTitle('이런 분들에게 추천!', Icons.favorite, isDark),
                  SizedBox(height: 16),
                  _buildCard(
                    child: Column(
                      children: [
                        _buildRecommendationItem('동네 소식이 궁금한 분', isDark),
                        _buildRecommendationItem('이웃들과 소통하고 싶은 분', isDark),
                        _buildRecommendationItem('빠르게 사건을 공유하고 싶은 분', isDark),
                        _buildRecommendationItem('지역 커뮤니티를 만들고 싶은 분', isDark),
                        SizedBox(height: 10),
                        Text(
                          '소이지와 함께, 이웃이 더 가까워집니다! 🏡💖',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.amber
                                : Colors.deepPurple.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    isDark: isDark,
                  ),

                  SizedBox(height: 40),

                  // 시작하기 버튼
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark ? Colors.deepPurple[700] : Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: isDark ? 3 : 5,
                      ),
                      child: Text(
                        '소이지 시작하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDark ? Colors.amber : Colors.deepPurple,
          size: 28,
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.amber[200] : Colors.deepPurple.shade800,
          ),
        ),
      ],
    );
  }

  // 카드 위젯
  Widget _buildCard({required Widget child, bool isDark = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: isDark ? 0 : 1,
            blurRadius: isDark ? 4 : 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // 기능 카드 위젯
  Widget _buildFeatureCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    bool isDark = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: isDark ? 0 : 1,
            blurRadius: isDark ? 4 : 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[300] : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 추천 아이템 위젯
  Widget _buildRecommendationItem(String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isDark ? Colors.amber : Colors.deepPurple,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
