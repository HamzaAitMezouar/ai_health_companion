abstract class Endpoints {
  static const String chatCompletions = '/chat/completions';
}

abstract class LLMModels {
  static const String gpt5 = '"gpt-5.5"';
  static const String gemma3Url =
      "https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task";
  static const String gemma3 = "gemma3-270m-it-q8.task";
}
