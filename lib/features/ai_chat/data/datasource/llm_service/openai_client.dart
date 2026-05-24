import 'dart:async';
import 'dart:convert';

import 'package:ai_health_companion/core/constants/endpoints.dart';
import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:ai_health_companion/core/network/dio_exception_handler.dart';
import 'package:ai_health_companion/core/network/dio_provider.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/llm_service/llm_client.dart';
import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenAiClient implements LlmClient {
  final Dio _dio;
  // final String _model;

  OpenAiClient({required Dio dio, required String model}) : _dio = dio;
  //  _model = model;

  @override
  Stream<String> streamCompletion(List<ChatMessage> messages) async* {
    final apiMessages = messages.map((m) => m.toApiMap()).toList().toString();

    try {
      final response = await _dio.post<ResponseBody>(
        Endpoints.chatCompletions,
        //  FOR OPEN AI  data: {'model': "gpt-5.5", 'stream': true, 'messages': apiMessages},
        data: {
          "model": "openai/gpt-4o",
          "messages": [
            {"role": "user", "content": apiMessages},
          ],
          "session_id": "my-session-123",
          "stream": true,
          "max_tokens": 1000,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final lines = response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in lines) {
        if (!line.startsWith('data: ')) continue;

        final payload = line.substring(6).trim();
        if (payload == '[DONE]') break;

        try {
          final json = jsonDecode(payload) as Map<String, dynamic>;
          final choices = json['choices'] as List;
          if (choices.isEmpty) continue;

          final delta = choices.first['delta'] as Map<String, dynamic>;
          final token = delta['content'] as String?;

          if (token != null && token.isNotEmpty) {
            yield token;
          }
        } catch (_) {}
      }
    } on DioException catch (e) {
      if (e.response?.data is ResponseBody) {
        try {
          final responseBody = e.response!.data as ResponseBody;

          final errorBytes = await responseBody.stream.toList();
          final flatBytes = errorBytes.expand((bit) => bit).toList();
          final errorText = utf8.decode(flatBytes);

          debugPrint('🚨 EXACT OPENAI ERROR DETAILS: $errorText');
        } catch (parseError) {
          debugPrint('Failed to parse streamed error body: $parseError');
        }
      }
      throw e.toCustomException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  void dispose() => _dio.close();
}

final llmClientProvider = Provider<LlmClient>((ref) {
  const llmModel = LLMModels.gpt5;
  final client = OpenAiClient(dio: ref.watch(llmDioProvider), model: llmModel);

  ref.onDispose(client.dispose);

  return client;
});
