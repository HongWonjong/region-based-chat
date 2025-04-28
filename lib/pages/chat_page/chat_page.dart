import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/chat_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String markerId;

  const ChatPage({
    super.key,
    required this.markerId,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider);
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      _focusNode.requestFocus();
      _scrollToBottom(); // 초기 로드 시 최하단으로 스크롤
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickAndSendImage() async {
    final user = ref.read(authProvider);
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        await ref
            .read(chatNotifierProvider(ChatParams(widget.markerId)).notifier)
            .sendImage(image);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(); // 이미지 업로드 후 최하단으로 스크롤
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('로그인이 필요합니다.')),
      );
    }

    final params = ChatParams(widget.markerId);
    final messages = ref.watch(chatNotifierProvider(params));
    final chatAsync = ref.watch(chatProvider(params));

    ref.listen(chatNotifierProvider(params), (previous, next) {
      if (next.length != (previous?.length ?? 0)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(); // 메시지 목록 변경 시 최하단으로 스크롤
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: chatAsync.when(
          data: (chat) => Text(
            chat != null
                ? '${chat.title}  ( ${chat.participants.length} )'
                : '로딩 중...',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          loading: () => const Text(
            '로딩 중...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          error: (error, stack) => Text(
            '오류 발생: $error',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('메시지가 없습니다.'))
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              reverse: true, // 리스트 역순 렌더링
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message.senderId == user.uid;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe) ...[
                        FutureBuilder<String?>(
                          future: ref
                              .read(chatRepositoryProvider)
                              .getProfileImageUrl(message.senderId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.error),
                              );
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: snapshot.data != null
                                  ? NetworkImage(snapshot.data!)
                                  : null,
                              child: snapshot.data == null
                                  ? const Icon(Icons.person)
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                      Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Text(
                              message.senderName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.of(context).size.width * 0.6,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.blue[100]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: message.type == 'image'
                                ? Image.network(
                              message.message,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                              // 추천: cached_network_image 사용 시
                              // placeholder: CircularProgressIndicator(),
                              // errorWidget: Icon(Icons.error),
                            )
                                : Text(
                              message.message,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('오전 h:mm')
                                .format(message.timestamp),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 8),
                        FutureBuilder<String?>(
                          future: ref
                              .read(chatRepositoryProvider)
                              .getProfileImageUrl(user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const CircleAvatar(
                                radius: 20,
                                child: Icon(Icons.error),
                              );
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: snapshot.data != null
                                  ? NetworkImage(snapshot.data!)
                                  : null,
                              child: snapshot.data == null
                                  ? const Icon(Icons.person)
                                  : null,
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickAndSendImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      try {
                        ref
                            .read(chatNotifierProvider(params).notifier)
                            .sendMessage(_controller.text, 'text');
                        _controller.clear();
                        _focusNode.requestFocus();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom(); // 메시지 전송 후 최하단으로 스크롤
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('메시지 전송 실패: $e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}