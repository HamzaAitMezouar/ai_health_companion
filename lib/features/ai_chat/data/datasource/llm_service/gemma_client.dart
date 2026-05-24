import 'dart:async';

import 'package:ai_health_companion/core/constants/app_env.dart';
import 'package:ai_health_companion/core/constants/endpoints.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'llm_client.dart';
import '../../models/chat_message.dart';

class GemmaClient implements LlmClient {
  AppEnv appEnv;
  GemmaClient(this.appEnv);
  @override
  Stream<String> streamCompletion(List<ChatMessage> messages) async* {
    final apiMessages = messages.map((m) => m.toApiMap()).toList().toString();
    final gemma = FlutterGemmaPlugin.instance;

    try {
      final docDir = await getApplicationDocumentsDirectory();

      final String absoluteModelPath = '${docDir.path}/${LLMModels.gemma3}';

      // ignore: deprecated_member_use
      await gemma.modelManager.setModelPath(absoluteModelPath);
      final model = await FlutterGemma.getActiveModel(
        maxTokens: 512,
        preferredBackend: PreferredBackend.gpu,
      );

      final chat = await model.createChat(systemInstruction: apiMessages);
      for (final m in messages.where((m) => m.role != MessageRole.system)) {
        await chat.addQueryChunk(Message.text(text: m.content, isUser: true));
      }

      await for (final response in chat.generateChatResponseAsync()) {
        if (response is TextResponse && response.token.isNotEmpty) {
          yield response.token;
        }
      }
    } catch (e) {}
  }

  Future<bool> isModelInstalled() async {
    FlutterGemma.listInstalledModels().then((c) {});
    final isInstalled = await FlutterGemma.isModelInstalled(LLMModels.gemma3);
    return isInstalled;
  }

  Future<bool> installModel(void Function(int progress)? onProgress) async {
    try {
      final hugginFaceToken = appEnv.huggineFaceToken;
      if (hugginFaceToken == null) return false;
      await FlutterGemma.installModel(modelType: ModelType.gemmaIt)
          .fromNetwork(LLMModels.gemma3Url, token: hugginFaceToken)
          .withProgress((progress) {
            onProgress?.call(progress);
          })
          .install();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {}
}

final gemmaClientProvider = Provider<GemmaClient>((ref) {
  final client = GemmaClient(ref.watch(envProvider));

  ref.onDispose(client.dispose);

  return client;
});
