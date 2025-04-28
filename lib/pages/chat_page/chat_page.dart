import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/chat_providers.dart';
import '../../style/style.dart';
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
      _scrollToBottom();
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
          _scrollToBottom();
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
          _scrollToBottom();
        });
      }
    });

    return Scaffold(
      backgroundColor: BackgroundStyles.chatBackgroundColor, // 배경 색상 적용
      body: CustomScrollView(
        slivers: [
          // ServiceIntroPage 스타일의 SliverAppBar
          SliverAppBar(
            expandedHeight: 60.0,
            floating: false,
            pinned: true,
            backgroundColor: AppBarStyles.appBarBackgroundColor, // 앱바 색상 적용
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              color: AppBarStyles.appBarIconTheme.color, // 아이콘 색상 적용
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: chatAsync.when(
                data: (chat) => Text(
                  chat != null
                      ? '${chat.title} (${chat.participants.length})'
                      : '로딩 중...',
                  style: AppBarStyles.appBarTitleStyle, // 앱바 타이틀 스타일 적용
                ),
                loading: () => Text(
                  '로딩 중...',
                  style: AppBarStyles.appBarTitleStyle,
                ),
                error: (error, stack) => Text(
                  '오류 발생: $error',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppBarStyles.appBarGradientStart, // 그라데이션 시작 색상
                          AppBarStyles.appBarGradientEnd, // 그라데이션 끝 색상
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 채팅 메시지 리스트
          SliverToBoxAdapter(
            child: messages.isEmpty
                ? const Center(child: Text('메시지가 없습니다.'))
                : Container(
              height: MediaQuery.of(context).size.height - 150,
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length,
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
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade800,
                                ),
                              ),
                            _buildMessageCard(
                              context,
                              message: message,
                              isMe: isMe,
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
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ButtonStyles.imageButtonBackgroundColor, // 이미지 버튼 색상 적용
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.image,
                  color: ButtonStyles.buttonIconColor, // 아이콘 색상 적용
                ),
                onPressed: _pickAndSendImage,
              ),
            ),
            Expanded(
              child: _buildTextField(),
            ),
            const SizedBox(width: 8),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  // 메시지 카드
  Widget _buildMessageCard(
      BuildContext context, {
        required dynamic message,
        required bool isMe,
      }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      padding: MessageCardStyles.messagePadding, // 메시지 패딩 적용
      decoration: BoxDecoration(
        color: isMe
            ? MessageCardStyles.myMessageColor
            : MessageCardStyles.otherMessageColor, // 메시지 색상 적용
        borderRadius: MessageCardStyles.messageBorderRadius, // 메시지 테두리 적용
        boxShadow: [MessageCardStyles.messageShadow], // 메시지 그림자 적용
      ),
      child: message.type == 'image'
          ? Image.network(
        message.message,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      )
          : Text(
        message.message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // 텍스트 필드
  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: TextFieldStyles.textFieldBackgroundColor, // 텍스트 필드 배경 색상
        borderRadius: TextFieldStyles.textFieldBorderRadius, // 텍스트 필드 테두리
        boxShadow: [TextFieldStyles.textFieldShadow], // 텍스트 필드 그림자
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: '메시지를 입력하세요...',
          border: OutlineInputBorder(
            borderRadius: TextFieldStyles.textFieldBorderRadius,
            borderSide: BorderSide.none,
          ),
          contentPadding: TextFieldStyles.textFieldPadding, // 패딩 적용
          filled: true,
          fillColor: TextFieldStyles.textFieldFillColor, // 채우기 색상
        ),
      ),
    );
  }

  // 전송 버튼
  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: () {
        if (_controller.text.isNotEmpty) {
          try {
            ref
                .read(chatNotifierProvider(ChatParams(widget.markerId)).notifier)
                .sendMessage(_controller.text, 'text');
            _controller.clear();
            _focusNode.requestFocus();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('메시지 전송 실패: $e')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonStyles.buttonBackgroundColor, // 버튼 색상 적용
        foregroundColor: ButtonStyles.buttonIconColor, // 버튼 아이콘 색상 적용
        padding: ButtonStyles.buttonPadding, // 버튼 패딩 적용
        shape: const CircleBorder(),
        elevation: ButtonStyles.buttonElevation, // 버튼 그림자 적용
      ),
      child: const Icon(Icons.send, size: 24),
    );
  }
}