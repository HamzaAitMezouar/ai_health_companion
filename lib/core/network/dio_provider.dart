import 'package:ai_health_companion/core/constants/app_env.dart';
import 'package:ai_health_companion/core/network/dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final llmDioProvider = Provider<Dio>((ref) {
  final config = ref.watch(envProvider);

  final dio = Dio(
    BaseOptions(
      headers: {
        'Authorization': 'Bearer ${config.apiToken}',
        'Content-Type': 'application/json',
      },
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(RetryDioInterceptor(dio: dio));
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: false));

  ref.onDispose(dio.close);

  return dio;
});
