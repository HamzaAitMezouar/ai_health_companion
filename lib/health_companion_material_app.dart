import 'package:ai_health_companion/core/theme/theme.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class HealthCompanionApp extends StatelessWidget {
  const HealthCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Companion',
      theme: AppTheme.light,
      home: ChatScreen(),
    );
  }
}
