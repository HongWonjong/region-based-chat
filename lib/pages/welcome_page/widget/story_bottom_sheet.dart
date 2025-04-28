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
      maxChildSize: 0.6,
      snap: true,
      snapSizes: [0.05, 0.6],
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final route = MaterialPageRoute(builder: (context) => ChatPage(markerId: markerProvider!.id));
                            Navigator.push(context, route);
                          },
                          child: Text("채팅방 참여하기"),
                        ),
                      ),
                    ),
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

    return [
      Row(
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
            height: 50,
            width: 50,
            child: Icon(Icons.person),
          ),
          SizedBox(width: 10),
          Text(marker.createdBy)
        ],
      ),
      SizedBox(height: 10),
      Divider(thickness: 2, color: Colors.grey[300]),
      Text(marker.title, style: TextStyle(fontSize: 20)),
      Row(
        children: [
          Text(marker.type.typeKor, style: TextStyle(color: Colors.grey[500])),
          Text(" ${dateConvert(marker.createdAt)}", style: TextStyle(color: Colors.grey[500]))
        ],
      ),
      SizedBox(height: 10),
      Text(marker.description),
      SizedBox(height: 30),
    ];
  }
}
