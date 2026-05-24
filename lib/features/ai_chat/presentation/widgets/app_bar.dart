part of '../screens/chat_screen.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context, ref) {
    final chatState = ref.watch(chatProvider);
    return AppBar(
      title: Column(
        children: [
          const Text('HAM'),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: chatState.isStreaming
                ? Text(
                    Lists.kAiThinkingMessages[Random().nextInt(
                      Lists.kAiThinkingMessages.length,
                    )],
                    key: ValueKey('thinking'),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                  )
                : const Text(
                    'Health Companion',
                    key: ValueKey('idle'),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                  ),
          ),
        ],
      ),
      actions: [
        _InstallOfflineModel(),
        if (!chatState.isEmpty)
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 20,
              color: AppTheme.error,
            ),
            tooltip: 'Clear conversation',
            onPressed: () => _confirmClear(context, ref),
          ),
        SizedBox(width: 6),
      ],
    );
  }
}

void _confirmClear(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Clear conversation?',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'This will permanently delete your conversation history.',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(chatProvider.notifier).clearConversation();
          },
          child: const Text(
            'Clear',
            style: TextStyle(color: AppTheme.shinnyRed),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

class _InstallOfflineModel extends ConsumerWidget {
  const _InstallOfflineModel();

  @override
  Widget build(BuildContext context, ref) {
    final installState = ref.watch(modelinstallProvider);

    return installState.when(
      data: (state) => switch (state) {
        ModelInstalledState() => Icon(Icons.offline_pin, color: AppTheme.green),
        ModelNotInstalledState() => IconButton(
          onPressed: () {
            _confirmInstall(context, ref);
          },
          icon: Icon(Icons.install_mobile_outlined),
        ),
        ModelrInstallInProgressState(progress: final p) => Text("${p ?? 0}%"),
        _ => SizedBox(),
      },
      loading: () => CupertinoActivityIndicator(),
      error: (err, stack) => IconButton(
        onPressed: () {
          _confirmInstall(context, ref, hadErrorr: true);
        },
        icon: Icon(Icons.error_outline, color: AppTheme.error),
      ),
    );
  }
}

void _confirmInstall(BuildContext context, WidgetRef ref, {bool? hadErrorr}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        hadErrorr == true
            ? "Your last try failled because of an error, please check your intrnet and try again"
            : 'Do you want to Install an offline Ai model to your device ?',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'You can install this model to use the application when you have no internet.\nPS: The offline model is not accurate as the online one',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(modelinstallProvider.notifier).installModel();
          },
          child: const Text('Install', style: TextStyle(color: AppTheme.dark)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
