part of '../screens/chat_screen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: AppTheme.green),
              ),
              child: Center(
                child: Text(
                  "HAM",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.green,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'HAM health companion ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tell me how you're feeling. I'll listen carefully and help.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 32),
            const _SuggestionChip(text: 'I\'ve had a headache for two days'),
            const SizedBox(height: 8),
            const _SuggestionChip(
              text: 'My throat has been sore since yesterday',
            ),
            const SizedBox(height: 8),
            const _SuggestionChip(text: 'I feel more tired than usual'),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends ConsumerWidget {
  const _SuggestionChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(chatProvider.notifier).sendMessage(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightGrey.withAlpha(60),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
