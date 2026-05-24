# AI Health Companion

A Flutter mobile app where users can have a conversation with an AI health companion.

## Setup

1. Clone the repo
2. Xreate `.env` and fill in your values:

```env
API_TOKEN=your-openai-api-key
API_BASE_URL="https://openrouter.ai/api/v1"
HUGGINGFACE_TOKEN=your-huggingface-token
```

3. Generate Drift files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run:

```bash
flutter run
```

## Architecture

The app is split into 2 layers:

- **core** has the string endpoint, theme, dio...
- **features/ai_chat** contains :
  - **Data** — LLM clients, Drift persistence, Models
  - **Presentation** — Riverpod notifiers, UI
**NOTE** No domain layer was used to keep the code simple without over-engenierring it. The data layer is connected directly with the providers.
The core abstraction is `LlmClient`, an interface that both `OpenAiClient` and `GemmaClient` implement. The rest of the app depends only on this interface — swapping providers means writing a new implementation and changing one line in the provider.
Note: Currently the openAi code is commented and openrouter is used instead.

## State Management

Riverpod with a `ChatNotifier` (`Notifier<ChatState>`) and `AsyncNotifier` `ModelInstallNotifier<ModelInstallState>` .

## LLM Integration

Messages are streamed token by token using Dio with `ResponseType.stream`. Each token triggers a state update, which rebuilds only the last message bubble.

## Offline AI

When offline, the app falls back to an on-device Gemma 3 270M model. The model is downloaded with ModelInstallNotifier on first launch (~300MB) and runs entirely locally with no internet required after that.
**NOTE** To download the model click on the phone icon on the app bar and it will show the download progress
**NOTE2** User a physical device as emulator crashes

## Symptom Severity Slider

When a message contains a symptom keyword (headache, fever, chest pain, etc.), a severity slider appears inline in the chat. The user can rate their symptom 1–10 before sending. The severity is injected into the message context sent to the LLM:

## Conversation deletion

You can delete a conversatrion to start a new one.
The conversation lives in the phone local storage using drift

## APIs

- Go to openrouter and generate an api key for free. and add it to .env API_TOKEN
- Create an account in hugging face, Then go to settings and create a token with read only permission, then go to https://huggingface.co/google/gemma-3-270m-it and click Acknowledge license and Access, fill the form and click submit and then add the accesstoken to env HUGGINGFACE_TOKEN
