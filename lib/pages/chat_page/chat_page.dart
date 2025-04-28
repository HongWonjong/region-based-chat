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
  bool _isComposing = false;

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

    _controller.addListener(() {
      setState(() {
        _isComposing = _controller.text.isNotEmpty;
      });
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
      backgroundColor: BackgroundStyles.chatBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          color: BackgroundStyles.chatBackgroundColor,
          // 배경 이미지 추가
          // 주석 해제 시 assets 폴더에 chat_background.png 파일 추가 필요
          // image: BackgroundStyles.chatBackgroundImage,
        ),
        child: CustomScrollView(
          slivers: [
            // 앱바
            SliverAppBar(
              expandedHeight: 70.0,
              floating: false,
              pinned: true,
              backgroundColor: AppBarStyles.appBarBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                color: AppBarStyles.appBarIconTheme.color,
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: chatAsync.when(
                  data: (chat) => Text(
                    chat != null
                        ? '${chat.title} (${chat.participants.length})'
                        : '로딩 중...',
                    style: AppBarStyles.appBarTitleStyle,
                  ),
                  loading: () => const Text(
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
                    // 그라데이션 배경
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppBarStyles.appBarGradientStart,
                            AppBarStyles.appBarGradientEnd,
                          ],
                        ),
                      ),
                    ),
                    // 시각적 효과를 위한 원형 장식
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    // 하단 정보 영역
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    // 채팅방 정보 화면으로 이동
                  },
                  color: Colors.white,
                ),
              ],
            ),

            // 채팅 메시지 리스트
            SliverToBoxAdapter(
              child: messages.isEmpty
                  ? Container(
                      height: MediaQuery.of(context).size.height - 160,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '아직 메시지가 없습니다.\n첫 메시지를 보내보세요!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height - 160,
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == user.uid;

                          // 날짜 변경 여부 확인 (날짜 구분선 표시용)
                          bool isNewDay = false;
                          if (index == messages.length - 1) {
                            isNewDay = true;
                          } else {
                            final currentDate = DateFormat('yyyy-MM-dd')
                                .format(message.timestamp);
                            final previousDate = DateFormat('yyyy-MM-dd')
                                .format(messages[index + 1].timestamp);
                            isNewDay = currentDate != previousDate;
                          }

                          return Column(
                            children: [
                              // 날짜 구분선
                              if (isNewDay)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: Text(
                                      DateFormat('yyyy년 MM월 dd일')
                                          .format(message.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                              // 메시지 버블
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment: isMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!isMe) ...[
                                      FutureBuilder<String?>(
                                        future: ref
                                            .read(chatRepositoryProvider)
                                            .getProfileImageUrl(
                                                message.senderId),
                                        builder: (context, snapshot) {
                                          return CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.grey[200],
                                            backgroundImage: snapshot.data !=
                                                    null
                                                ? NetworkImage(snapshot.data!)
                                                : null,
                                            child: snapshot.data == null
                                                ? const Icon(Icons.person,
                                                    size: 18,
                                                    color: Colors.grey)
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, bottom: 4),
                                            child: Text(
                                              message.senderName,
                                              style: MessageCardStyles
                                                  .senderNameStyle,
                                            ),
                                          ),

                                        // 메시지 내용과 시간을 가로로 배치
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            // 시간 (내 메시지일 경우 왼쪽)
                                            if (isMe)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Text(
                                                  DateFormat('HH:mm').format(
                                                      message.timestamp),
                                                  style: MessageCardStyles
                                                      .timeTextStyle,
                                                ),
                                              ),

                                            // 메시지 버블
                                            _buildMessageCard(
                                              context,
                                              message: message,
                                              isMe: isMe,
                                            ),

                                            // 시간 (상대방 메시지일 경우 오른쪽)
                                            if (!isMe)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                  DateFormat('HH:mm').format(
                                                      message.timestamp),
                                                  style: MessageCardStyles
                                                      .timeTextStyle,
                                                ),
                                              ),
                                          ],
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
                                            radius: 16,
                                            backgroundColor: Colors.purple[100],
                                            backgroundImage: snapshot.data !=
                                                    null
                                                ? NetworkImage(snapshot.data!)
                                                : null,
                                            child: snapshot.data == null
                                                ? const Icon(Icons.person,
                                                    size: 18,
                                                    color: Colors.deepPurple)
                                                : null,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      // 하단 입력창
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 8,
            bottom: 8 + MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 이미지 첨부 버튼
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      ButtonStyles.imageButtonBackgroundColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.image_outlined),
                  color: ButtonStyles.imageButtonBackgroundColor,
                  onPressed: _pickAndSendImage,
                  tooltip: '이미지 첨부',
                  iconSize: 26,
                ),
              ),

              // 메시지 입력 필드
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: TextFieldStyles.textFieldBorderRadius,
                    boxShadow: [TextFieldStyles.textFieldShadow],
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: TextFieldStyles.textFieldDecoration,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // 전송 버튼
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration:
                    _isComposing ? ButtonStyles.sendButtonDecoration : null,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: _isComposing
                        ? () {
                            if (_controller.text.isNotEmpty) {
                              try {
                                ref
                                    .read(chatNotifierProvider(
                                            ChatParams(widget.markerId))
                                        .notifier)
                                    .sendMessage(_controller.text, 'text');
                                _controller.clear();
                                _focusNode.requestFocus();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('메시지 전송 실패: $e')),
                                );
                              }
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send_rounded,
                        color: _isComposing ? Colors.white : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      padding: MessageCardStyles.messagePadding,
      decoration: BoxDecoration(
        color: isMe
            ? MessageCardStyles.myMessageColor
            : MessageCardStyles.otherMessageColor,
        borderRadius: isMe
            ? MessageCardStyles.myMessageBorderRadius
            : MessageCardStyles.otherMessageBorderRadius,
        boxShadow: [MessageCardStyles.messageShadow],
      ),
      child: message.type == 'image'
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  // 이미지 전체 화면 보기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          iconTheme: const IconThemeData(color: Colors.white),
                          elevation: 0,
                        ),
                        body: Center(
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: Image.network(
                              message.message,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Image.network(
                  message.message,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 200,
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple.shade300,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : Text(
              message.message,
              style: TextStyle(
                fontSize: 15,
                color: isMe
                    ? MessageCardStyles.myTextColor
                    : MessageCardStyles.otherTextColor,
              ),
            ),
    );
  }
}
