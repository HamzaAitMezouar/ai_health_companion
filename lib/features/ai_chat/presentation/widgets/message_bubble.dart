part of '../screens/chat_screen.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isStreaming,
    this.onSeverityConfirm,
    this.onSeverityDismiss,
  });

  final ChatMessage message;

  final bool isStreaming;

  final void Function(String text, int severity)? onSeverityConfirm;
  final VoidCallback? onSeverityDismiss;

  bool get _isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.severityInput) {
      return SeveritySliderCard(
        onConfirm: onSeverityConfirm ?? (_, __) {},
        onDismiss: onSeverityDismiss ?? () {},
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: _isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!_isUser) _avatar(),
          const SizedBox(width: 8),
          Flexible(child: _bubble(context)),
          if (_isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: const Icon(Icons.person, color: AppTheme.dark, size: 16),
    );
  }

  Widget _bubble(BuildContext context) {
    final isAssistantStreaming =
        !_isUser && isStreaming && message.content.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isUser ? AppTheme.green : AppTheme.lightGrey,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(_isUser ? 20 : 4),
          bottomRight: Radius.circular(_isUser ? 4 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.type == MessageType.severityResult &&
              message.severityValue != null)
            _severityPill(),

          if (isAssistantStreaming)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TypingIndicator(),
            )
          else
            _messageText(),

          if (!_isUser && isStreaming && message.content.isNotEmpty)
            _streamingCursor(),
        ],
      ),
    );
  }

  Widget _messageText() {
    return Text(
      message.content,
      style: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: AppTheme.dark,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _severityPill() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: message.severityValue?.severityColor(),

        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart_rounded, size: 14, color: AppTheme.green),
          const SizedBox(width: 4),
          Text(
            'Severity: ${message.severityValue}/10',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.lightGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamingCursor() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: _BlinkingCursor(),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 2,
        height: 14,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
