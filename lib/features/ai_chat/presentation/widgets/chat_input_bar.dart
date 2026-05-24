part of '../screens/chat_screen.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onSeverityTap,
    required this.canSend,
  });

  final void Function(String text) onSend;
  final VoidCallback onSeverityTap;
  final bool canSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.canSend) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.lightGrey)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 8),

            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.canSend,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: "Describe how you're feeling...",
                ),
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(width: 8),

            _SendButton(
              onTap: _send,
              isEnabled: _hasText && widget.canSend,
              key: const ValueKey('send'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({super.key, required this.onTap, required this.isEnabled});
  final VoidCallback onTap;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Icon(
          Icons.send_rounded,
          color: isEnabled ? AppTheme.dark : AppTheme.grey,
          size: 20,
        ),
      ),
    );
  }
}
