import 'package:flutter/material.dart';

class StoryBottomSheet extends StatelessWidget {
  final DraggableScrollableController draggableController = DraggableScrollableController();

  StoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: draggableController,
      initialChildSize: 0.05,
      minChildSize: 0.05,
      maxChildSize: 0.8,
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
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("유저 닉네임"), Text("OO동", style: TextStyle(color: Colors.grey[500]))],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(thickness: 2, color: Colors.grey[300]),
                    Text("떡볶이 무료 시식 있습니다.", style: TextStyle(fontSize: 20)),
                    Row(
                      children: [Text("동네 행사", style: TextStyle(color: Colors.grey[500])), Text(" 5분전", style: TextStyle(color: Colors.grey[500]))],
                    ),
                    SizedBox(height: 10),
                    Text("교회 앞에서 떡볶이 무료 시식 행사가 있습니다.\n다들 와서 한입씩 하세요^^"),
                    SizedBox(height: 30),
                    ElevatedButton(onPressed: () {}, child: Text("채팅방 참여하기")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
