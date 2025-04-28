import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:region_based_chat/models/marker.dart';
import 'package:region_based_chat/pages/chat_page/chat_page.dart';
import 'package:region_based_chat/pages/welcome_page/util/date_onvert.dart';
import 'package:region_based_chat/providers/marker_provider.dart';

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
      snapSizes: [0.05, 0.8],
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 4,
                    width: 80,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(30),
                sliver: SliverList.list(
                  children: _content(markerProvider, context),
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

  List<Widget> _content(Marker? marker, BuildContext context) {
    if (marker == null) {
      return [Text("지도의 마커를 클릭해 다양한 소문들을 확인해보세요!")];
    }

    final List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blueAccent),
                height: 50,
                width: 50,
                child: Icon(Icons.person),
              ),
              SizedBox(width: 10),
              Text(marker.createdBy),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              final route = MaterialPageRoute(
                  builder: (context) => ChatPage(markerId: marker.id));
              Navigator.push(context, route);
            },
            icon: Icon(Icons.chat_bubble_outline, size: 18),
            label: Text("채팅방 참여"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Divider(thickness: 2, color: Colors.grey[300]),
      Text(marker.title, style: TextStyle(fontSize: 20)),
      Row(
        children: [
          Text(marker.type.typeKor, style: TextStyle(color: Colors.grey[500])),
          Text(" ${dateConvert(marker.createdAt)}",
              style: TextStyle(color: Colors.grey[500]))
        ],
      ),
      SizedBox(height: 10),
      Text(marker.description),
      SizedBox(height: 20),
    ];

    if (marker.imageUrls.isNotEmpty) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '첨부된 사진 (${marker.imageUrls.length})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            _buildImageGallery(marker.imageUrls, context),
          ],
        ),
      );
    }

    widgets.add(SizedBox(height: 30));

    return widgets;
  }

  Widget _buildImageGallery(List<String> imageUrls, BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(context, imageUrls, index),
            child: Container(
              width: 200,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            itemCount: imageUrls.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
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
