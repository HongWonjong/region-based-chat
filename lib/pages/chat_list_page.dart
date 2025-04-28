import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
        backgroundColor: Colors.pink[50],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              ListTile(
                dense: true,
                title: Text(
                  'test1',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '어디로 가면될까요',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(thickness: 0.5, height: 0.5),
              ListTile(
                dense: true,
                title: Text(
                  'test1',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '어디로 가면될까요',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(thickness: 0.5, height: 0.5),
              ListTile(
                dense: true,
                title: Text(
                  'test1',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '어디로 가면될까요',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Divider(thickness: 0.5, height: 0.5),
            ],
          ),
        ],
      ),
    );
  }
}





//1. 브랜치 만들기
//2. ChatListPage에 UI 구현
//3. git add
//4. git commit
//5. 브랜치 푸시
//6. Pull Request 날리기
