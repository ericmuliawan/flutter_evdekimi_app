import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/common/di/service_locator.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/repositories/chat_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/presentation/cubits/chat_cubit.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/presentation/cubits/chat_state.dart';
import 'package:flutter_evdekimi_app/feature/home/presentation/widgets/chat_empty_state.dart';
import 'package:flutter_evdekimi_app/feature/home/presentation/widgets/chat_input_bar.dart';
import 'package:flutter_evdekimi_app/feature/home/presentation/widgets/chat_message_bubble.dart';
import 'package:flutter_evdekimi_app/feature/home/presentation/widgets/typing_indicator.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(repository: getIt<IChatRepository>()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _messageController.clear();
    context.read<ChatCubit>().sendMessage(trimmed);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      final isNearBottom = position.maxScrollExtent - position.pixels < 160;
      if (!isNearBottom) return;
      _scrollController.jumpTo(position.maxScrollExtent);
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColor.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EVDEKimi',
              style: AppTextStyle.smallTitle.apply(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeightDelta: 6,
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.radius10),
              ),
              child: Text(
                'AI',
                style: AppTextStyle.labelButtonSmall.apply(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeightDelta: 3,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Clear chat',
            onPressed: () => context.read<ChatCubit>().clearChat(),
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _showError(state.errorMessage!);
          }
          _scrollToBottom();
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? ChatEmptyState(onSuggestionTap: _onSend)
                    : _buildMessageList(state),
              ),
              ChatInputBar(
                controller: _messageController,
                isGenerating: state.isGenerating,
                onSend: () => _onSend(_messageController.text),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing16,
        AppSpacing.spacing16,
        AppSpacing.spacing24,
      ),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final showTyping = state.isGenerating &&
            index == state.messages.length - 1 &&
            message.text.isEmpty;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
          child: showTyping
              ? const TypingIndicator()
              : ChatMessageBubble(message: message),
        );
      },
    );
  }
}
