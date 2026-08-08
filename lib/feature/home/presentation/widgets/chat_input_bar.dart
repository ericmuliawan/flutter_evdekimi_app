import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_evdekimi_app/feature/chatbot/domain/services/speech_to_text_service.dart';
import 'package:flutter_evdekimi_app/uikit/token/index.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isGenerating,
    required this.onSend,
    required this.speechService,
  });

  final TextEditingController controller;
  final bool isGenerating;
  final void Function(
    String text, {
    Uint8List? imageBytes,
    String? imageMimeType,
  }) onSend;
  final SpeechToTextService speechService;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _focusNode = FocusNode();
  final _imagePicker = ImagePicker();

  Uint8List? _selectedImageBytes;
  String? _selectedImageMimeType;

  bool _isListening = false;
  bool _isInitializing = false;

  bool get _hasImage => _selectedImageBytes != null;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.speechService.cancel();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await widget.speechService.stop();
      _setListening(false);
      return;
    }
    if (_isInitializing) return;

    setState(() => _isInitializing = true);
    final initialized = await widget.speechService.initialize();
    if (!mounted) return;

    setState(() => _isInitializing = false);
    if (!initialized) {
      _showSpeechError();
      return;
    }

    try {
      await widget.speechService.startListening(onResult: _onSpeechResult);
      _setListening(true);
    } catch (_) {
      _showSpeechError();
    }
  }

  void _onSpeechResult(String text, bool isFinal) {
    if (!mounted) return;
    if (text.isNotEmpty) {
      widget.controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
    if (isFinal) {
      _setListening(false);
      if (text.trim().isNotEmpty && !widget.isGenerating) {
        _send();
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1440,
        maxHeight: 1440,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageMimeType = file.mimeType ?? _inferMimeType(file.path);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load the selected image.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageMimeType = null;
    });
  }

  void _send() {
    final text = widget.controller.text;
    final imageBytes = _selectedImageBytes;
    final imageMimeType = _selectedImageMimeType;
    if (text.trim().isEmpty && imageBytes == null) return;
    if (imageBytes != null) _removeImage();
    widget.onSend(text, imageBytes: imageBytes, imageMimeType: imageMimeType);
  }

  void _setListening(bool value) {
    if (!mounted || _isListening == value) return;
    setState(() => _isListening = value);
  }

  void _showSpeechError() {
    final message = widget.speechService.lastError ??
        'Speech recognition is not available on this device.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _inferMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic')) return 'image/heic';
    if (lower.endsWith('.bmp')) return 'image/bmp';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFocused = _focusNode.hasFocus;
    final canSendText = widget.controller.text.trim().isNotEmpty;
    final showSend = (isFocused && canSendText) || _hasImage;
    final canSend = canSendText || _hasImage;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacing16,
        AppSpacing.spacing12,
        AppSpacing.spacing16,
        AppSpacing.spacing12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasImage) ...[
            _buildImagePreview(colorScheme),
            const SizedBox(height: AppSpacing.spacing12),
          ],
          Row(
            children: [
              IconButton(
                tooltip: 'Attach image',
                onPressed: widget.isGenerating || _isListening
                    ? null
                    : _pickImage,
                icon: const Icon(Icons.image_outlined),
                color: colorScheme.onSurfaceVariant,
                disabledColor: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.spacing5),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => widget.isGenerating ? null : _send(),
                  decoration: InputDecoration(
                    hintText: _isListening
                        ? 'Listening...'
                        : 'Ask EVDEKimi AI...',
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing20,
                      vertical: AppSpacing.spacing12,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radius25),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.radius25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing12),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  tooltip: _isListening
                      ? 'Stop listening'
                      : showSend
                      ? 'Send'
                      : 'Speak',
                  onPressed: widget.isGenerating || _isInitializing
                      ? null
                      : showSend
                      ? canSend
                          ? _send
                          : null
                      : _toggleListening,
                  style: IconButton.styleFrom(
                    backgroundColor: _isListening
                        ? colorScheme.errorContainer
                        : showSend
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    disabledBackgroundColor:
                        colorScheme.surfaceContainerHighest,
                    foregroundColor: _isListening
                        ? colorScheme.onErrorContainer
                        : showSend
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    disabledForegroundColor: colorScheme.onSurfaceVariant,
                  ),
                  icon: _isInitializing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _isListening
                              ? Icons.mic_rounded
                              : showSend
                              ? Icons.arrow_upward_rounded
                              : Icons.mic_none_rounded,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing8,
          vertical: AppSpacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.radius10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radius4),
              child: Image.memory(
                _selectedImageBytes!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.spacing12),
            const Text('Image attached'),
            const SizedBox(width: AppSpacing.spacing5),
            IconButton(
              tooltip: 'Remove image',
              onPressed: _removeImage,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
