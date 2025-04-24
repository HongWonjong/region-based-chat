import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/chat_providers.dart';

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

  @override
  void initState() {
    super.initState();
    print('ChatPage initialized');
    _focusNode.addListener(() {
      print('Focus changed: ${_focusNode.hasFocus}');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
      print('Scrolling to bottom');
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ChatPage build called');
    final params = ChatParams(widget.markerId);
    final messages = ref.watch(chatNotifierProvider(params));
    final chatAsync = ref.watch(chatProvider(params));

    ref.listen(chatNotifierProvider(params), (previous, next) {
      if (next.length > (previous?.length ?? 0)) {
        _scrollToBottom();
      }
    });

    print('Messages in UI: ${messages.length}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: chatAsync.when(
          data: (chat) => Text(
            chat?.title ?? '로딩 중...',
            style: const TextStyle(
              fontSize: 18,
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
          error: (error, stack) => const Text(
            '오류 발생',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
              itemBuilder: (context, index) {
                try {
                  final message = messages[index];
                  final isMe = message.senderId == 'wonjonghong';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe) ...[
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
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
                              child: Text(
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
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                } catch (e) {
                  print('Error rendering message at index $index: $e');
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    print('Add button pressed');
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (value) {
                      print('Text submitted: $value');
                      if (value.isNotEmpty) {
                        ref
                            .read(chatNotifierProvider(params).notifier)
                            .sendMessage(
                          'wonjonghong',
                          '홍원종',
                          value,
                          'text',
                        );
                        _controller.clear();
                        _focusNode.requestFocus();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    print('Send button pressed: ${_controller.text}');
                    if (_controller.text.isNotEmpty) {
                      ref
                          .read(chatNotifierProvider(params).notifier)
                          .sendMessage(
                        'wonjonghong',
                        '홍원종',
                        _controller.text,
                        'text',
                      );
                      _controller.clear();
                      _focusNode.requestFocus();
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