import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:region_based_chat/pages/chat_page/chat_page.dart';
import 'package:region_based_chat/pages/welcome_page/util/date_onvert.dart';
import 'package:region_based_chat/providers/marker_provider.dart';
import '../../../style/style.dart';

class StoryBottomSheet extends ConsumerWidget {
  final DraggableScrollableController draggableController;

  const StoryBottomSheet({super.key, required this.draggableController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markerProvider = ref.watch(selectedMarkerProvider);
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.8,
      snap: true,
      snapSizes: [0.05, 0.6, 0.8],
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,

          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(

                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList.list(
                  children: _content(markerProvider, context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _content(Marker? marker, BuildContext context) {
    if (marker == null) {
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppBarStyles.appBarGradientEnd.withOpacity(0.2),
                    border: Border.all(
                      color: AppBarStyles.appBarGradientEnd,
                      width: 1.5,
                    ),
                  ),
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF5E35B1),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.createdBy,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dateConvert(marker.createdAt),
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
                  colors: [
                    AppBarStyles.appBarGradientStart,
                    AppBarStyles.appBarGradientEnd
                  ],
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
                    final route = MaterialPageRoute(
                        builder: (context) => ChatPage(markerId: marker.id));
                    Navigator.push(context, route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
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
        color: Colors.grey[200],
        margin: const EdgeInsets.symmetric(vertical: 12),
      ),

      // 소문 제목과 카테고리를 한 행에 배치
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

              ),
            ),
          ),

              ),
            ),
          ),
        ],
      ),

      ),
      const SizedBox(height: 24),
    ];

    // 이미지가 있는 경우
    if (marker.imageUrls.isNotEmpty) {
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
                  '첨부된 사진 (${marker.imageUrls.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF7B1FA2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildImageGallery(marker.imageUrls, context),
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
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 50, right: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
            itemBuilder: (context, index) {

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
