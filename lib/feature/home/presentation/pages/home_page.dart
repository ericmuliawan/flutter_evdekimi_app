import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_evdekimi_app/common/di/service_locator.dart';
import 'package:flutter_evdekimi_app/common/local_storage_provider.dart';
import 'package:flutter_evdekimi_app/common/theme/theme_cubit.dart';
import 'package:flutter_evdekimi_app/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/repositories/chat_repository.dart';
import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/speech_to_text_service.dart';
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
      create: (_) => ChatCubit(
        repository: getIt<IChatRepository>(),
        localStorageProvider: getIt<ILocalStorageProvider>(),
      ),
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
  bool _offlineDialogShown = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadHistory();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend(
    String text, {
    Uint8List? imageBytes,
    String? imageMimeType,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty && imageBytes == null) return;
    _messageController.clear();
    context.read<ChatCubit>().sendMessage(
      trimmed,
      imageBytes: imageBytes,
      imageMimeType: imageMimeType,
    );
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

  Future<void> _showOfflineModelDialog() async {
    final shouldDownload = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Offline AI mode'),
          content: const Text(
            'You are offline and the on-device AI model is not downloaded yet. '
            'Download it once (about 470 MB) so you can keep chatting without '
            'an internet connection.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Download'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldDownload == true) {
      context.read<ChatCubit>().downloadOfflineModel();
    } else {
      context.read<ChatCubit>().dismissOfflinePrompt();
    }
  }

  Widget _buildDownloadProgress(double progress) {
    final colorScheme = Theme.of(context).colorScheme;
    final percent = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(0);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_for_offline_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              'Downloading offline AI model',
              style: AppTextStyle.smallTitle.apply(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '$percent%',
              style: AppTextStyle.subtitle.apply(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              borderRadius: BorderRadius.circular(AppRadius.radius10),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              'The model runs fully on your device and works offline.',
              style: AppTextStyle.bodySmall.apply(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark =
                  themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.dark);
              return IconButton(
                tooltip: isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: () => context.read<ThemeCubit>().toggle(
                  Theme.of(context).brightness,
                ),
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                ),
              );
            },
          ),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isOffline)
                    const Tooltip(
                      message: 'Offline mode',
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.cloud_off_outlined, size: 22),
                      ),
                    ),
                  IconButton(
                    tooltip: 'Clear chat',
                    onPressed: () => context.read<ChatCubit>().clearChat(),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ],
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await getIt<ILocalStorageProvider>().deleteAuthToken();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _showError(state.errorMessage!);
          }
          if (state.offlineModelMissing && !_offlineDialogShown) {
            _offlineDialogShown = true;
            _showOfflineModelDialog();
          } else if (!state.offlineModelMissing) {
            _offlineDialogShown = false;
          }
          _scrollToBottom();
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.isDownloading
                    ? _buildDownloadProgress(state.downloadProgress)
                    : state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.messages.isEmpty
                    ? ChatEmptyState(onSuggestionTap: _onSend)
                    : _buildMessageList(state),
              ),
              ChatInputBar(
                controller: _messageController,
                isGenerating: state.isGenerating || state.isLoading,
                onSend: (text, {imageBytes, imageMimeType}) => _onSend(
                  text,
                  imageBytes: imageBytes,
                  imageMimeType: imageMimeType,
                ),
                speechService: getIt<SpeechToTextService>(),
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
        final showTyping =
            state.isGenerating &&
            index == state.messages.length - 1 &&
            message.text.isEmpty;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
          child: showTyping
              ? const TypingIndicator()
              : ChatMessageBubble(
                  message: message,
                  senderLabel: message.isUser
                      ? (state.username ?? 'You')
                      : 'EVDEKimi AI',
                ),
        );
      },
    );
  }
}
