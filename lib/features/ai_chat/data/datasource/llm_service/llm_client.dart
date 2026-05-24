import 'package:ai_health_companion/features/ai_chat/data/models/chat_message.dart';

abstract class LlmClient {
  Stream<String> streamCompletion(List<ChatMessage> messages);

  void dispose();
}
