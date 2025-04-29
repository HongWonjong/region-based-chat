import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_list_viewmodel.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방'),
        backgroundColor: Colors.pink[50],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: chats.isEmpty
          ? const Center(child: Text('채팅방이 없습니다.'))
          : ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(thickness: 0.5, height: 0.5),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    chat.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
