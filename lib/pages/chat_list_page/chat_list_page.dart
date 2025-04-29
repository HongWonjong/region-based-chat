import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../chat_page/chat_page.dart';
import 'chat_list_view_model.dart';
import '../../style/style.dart';

class ChatListPage extends ConsumerWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : BackgroundStyles.chatBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 앱바
          SliverAppBar(
            expandedHeight: 70.0,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? Colors.grey[850] : AppBarStyles.appBarBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '채팅방',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.white,
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
                        colors: isDark
                            ? [
                          Colors.black,
                          Colors.grey[850]!,
                        ]
                            : [
                          AppBarStyles.appBarGradientStart,
                          AppBarStyles.appBarGradientEnd,
                        ],
                      ),
                    ),
                  ),
                  // 장식용 원형 요소
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 채팅 리스트
          SliverToBoxAdapter(
            child: chats.isEmpty
                ? Container(
              height: MediaQuery.of(context).size.height - 160,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 48,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '채팅방이 없습니다.',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chats.length,
              separatorBuilder: (_, __) => Divider(
                thickness: 0.5,
                height: 0.5,
                color: isDark ? Colors.grey[700] : Colors.grey.withOpacity(0.3),
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatTile(context, chat, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, dynamic chat, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(markerId: chat.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            chat.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            chat.lastMessage,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}