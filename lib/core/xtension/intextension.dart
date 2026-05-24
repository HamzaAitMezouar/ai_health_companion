import 'dart:ui';

import 'package:ai_health_companion/core/theme/theme.dart';

extension Intextension on int {
  Color severityColor() {
    if (this <= 3) return AppTheme.shinnyGreen;
    if (this <= 6) return AppTheme.shinnyOrange;
    return AppTheme.shinnyRed;
  }

  String get severityLabel {
    if (this <= 3) return 'Light';
    if (this <= 6) return 'Normal';
    return 'Severe';
  }
}
