import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class AppEnv {
  final String apiToken;
  final String apiBaseUrl;
  final String? huggineFaceToken;
  const AppEnv({
    required this.apiToken,
    required this.apiBaseUrl,
    this.huggineFaceToken,
  });
}

final envProvider = Provider<AppEnv>((ref) {
  final token = dotenv.env['API_TOKEN'];
  final baseUrl = dotenv.env['API_BASE_URL'];
  final huggineFaceToken = dotenv.env['HUGGING_FACE_TOKEN'];

  if (token == null || token.isEmpty || baseUrl == null || baseUrl.isEmpty) {
    throw const EnvironmentException();
  }

  return AppEnv(
    apiToken: token,
    apiBaseUrl: baseUrl,
    huggineFaceToken: huggineFaceToken,
  );
});
