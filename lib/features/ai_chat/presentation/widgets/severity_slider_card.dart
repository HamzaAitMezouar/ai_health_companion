part of '../screens/chat_screen.dart';

class SeveritySliderCard extends StatefulWidget {
  const SeveritySliderCard({
    super.key,
    required this.onConfirm,
    required this.onDismiss,
  });

  final void Function(String text, int severity) onConfirm;
  final VoidCallback onDismiss;

  @override
  State<SeveritySliderCard> createState() => _SeveritySliderCardState();
}

class _SeveritySliderCardState extends State<SeveritySliderCard> {
  double _value = 5;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.shinnyRed.withAlpha(90)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightGrey.withAlpha(60),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bar_chart_rounded,
                  color: AppTheme.green,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Rate your symptom severity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.dark,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppTheme.dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Describe your symptom (optional)...',
                hintStyle: TextStyle(fontSize: 13, color: AppTheme.dark),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_value.round()} / 10',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _value.toInt().severityColor(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _value.toInt().severityColor().withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _value.toInt().severityLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _value.toInt().severityColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _value.toInt().severityColor(),
                inactiveTrackColor: _value.toInt().severityColor().withAlpha(
                  30,
                ),
                thumbColor: _value.toInt().severityColor(),
                overlayColor: _value.toInt().severityColor().withAlpha(30),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: Slider(
                value: _value,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (v) => setState(() => _value = v),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No pain',
                    style: TextStyle(fontSize: 11, color: AppTheme.dark),
                  ),
                  Text(
                    'Worst pain',
                    style: TextStyle(fontSize: 11, color: AppTheme.dark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () =>
                    widget.onConfirm(_textController.text, _value.round()),
                child: const Text(
                  'Add severity rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
