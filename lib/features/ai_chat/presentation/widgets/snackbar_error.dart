part of '../screens/chat_screen.dart';

class SnackbarError {
  static void call(BuildContext context, CustomException? error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _friendlyMessage(error),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.shinnyRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }
}

String _friendlyMessage(CustomException? e) => switch (e) {
  NetworkException() => 'You\'re offline. Check your connection and try again.',
  TimeOutExceptiopn() => 'That took too long. Please try again.',
  UnknownException() => "Somethinw went wrong",
  EnvironmentException() => 'Something went wrong with the AI service.',
  _ => 'An unexpected error occurred. Please try again.',
};
