import 'package:ai_health_companion/health_companion_material_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemma/core/api/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await FlutterGemma.initialize();

  runApp(const ProviderScope(child: HealthCompanionApp()));
}
