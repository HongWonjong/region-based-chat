import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/story_model.dart';
import 'package:region_based_chat/pages/chat_page/chat_page.dart';
import 'package:region_based_chat/pages/welcome_page/util/date_onvert.dart';
import 'package:region_based_chat/providers/firebase/firebase_storage_provider.dart';
import 'package:region_based_chat/providers/marker_provider.dart';
import 'package:region_based_chat/services/firebase/firebase_storage_service.dart';
import 'package:region_based_chat/style/style.dart';

class StoryBottomSheet extends ConsumerWidget {
  final DraggableScrollableController draggableController;

  const StoryBottomSheet({super.key, required this.draggableController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markerProvider = ref.watch(selectedMarkerProvider);
    final FirebaseStorageService fireStorageProvider = ref.read(firebaseStorageServiceProvider);
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: [0.05, 0.8],
      builder: (BuildContext context, scrollController) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // 드래그 핸들
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList.list(
                  children: _content(markerProvider, context, fireStorageProvider, isDark),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 소문 내용 렌더링
  List<Widget> _content(StoryMarkerModel? story, BuildContext context, FirebaseStorageService fireStorageProvider, bool isDark) {
    if (story == null) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "지도의 마커를 클릭해 다양한 소문들을 확인해보세요!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        )
      ];
    }

    final List<Widget> widgets = [
      // 작성자 정보 및 채팅 버튼
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FutureBuilder<String>(
                  future: fireStorageProvider.getDownloadUrl(
                    fireStorageProvider.getProfileImageReference(story.uid),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // 로딩 중일 때 로딩 인디케이터 표시
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      // 에러 발생 시 기본 이미지 또는 에러 메시지 표시
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      // URL이 성공적으로 로드되었을 때 이미지 표시
                      return ClipOval(
                        child: Image.network(
                          snapshot.data!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      );
                    } else {
                      // 데이터가 없을 경우 기본 이미지 표시
                      return const SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(Icons.person, color: Colors.grey),
                      );
                    }
                  },
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.createdBy,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dateConvert(story.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppBarStyles.appBarGradientStart, AppBarStyles.appBarGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppBarStyles.appBarGradientStart.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    final route = MaterialPageRoute(builder: (context) => ChatPage(markerId: story.id));
                    Navigator.push(context, route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_bubble_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "채팅방 참여",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 구분선
      Container(
        height: 1,
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        margin: const EdgeInsets.symmetric(vertical: 12),
      ),

      // 소문 제목과 카테고리를 한 행에 배치
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              story.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.amber[100] : Color(0xFF4A148C),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: story.type.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              story.type.typeKor,
              style: TextStyle(
                color: story.type.color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // 소문 내용
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Text(
          story.description,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: isDark ? Colors.grey[100] : null,
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];

    // 이미지가 있는 경우
    if (story.imageUrls.isNotEmpty) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.photo_library,
                  color: Color(0xFF7B1FA2),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '첨부된 사진 (${story.imageUrls.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageGallery(story.imageUrls, context),
          ],
        ),
      );
    }

    widgets.add(const SizedBox(height: 30));

    return widgets;
  }

  Widget _buildImageGallery(List<String> imageUrls, BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(context, imageUrls, index),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(AppBarStyles.appBarGradientStart),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          width: 200,
                          height: 200,
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 확대 표시기
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${initialIndex + 1} / ${imageUrls.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          body: PageView.builder(
            itemCount: imageUrls.length,
            controller: PageController(initialPage: initialIndex),
            onPageChanged: (index) {
              // 페이지 인덱스 표시 업데이트
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${index + 1} / ${imageUrls.length}',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.black54,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 20, left: 50, right: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Center(
                  child: Hero(
                    tag: 'image_${imageUrls[index]}',
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
