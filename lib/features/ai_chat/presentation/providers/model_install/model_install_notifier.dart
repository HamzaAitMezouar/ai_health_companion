import 'dart:async';

import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:ai_health_companion/core/network/connectivity_service.dart';
import 'package:ai_health_companion/features/ai_chat/data/datasource/llm_service/gemma_client.dart';
import 'package:ai_health_companion/features/ai_chat/presentation/providers/model_install/modelinstall_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModelInstallNotifier extends AsyncNotifier<ModelInstallState> {
  late final ConnectivityService _connectivity;
  late final GemmaClient _gemmaClient;

  @override
  FutureOr<ModelInstallState> build() async {
    _connectivity = ref.watch(connectivityProvider);
    _gemmaClient = ref.watch(gemmaClientProvider);

    var isModelInstalled = await _gemmaClient.isModelInstalled();
    if (isModelInstalled) return ModelInstalledState();

    return ModelNotInstalledState();
  }

  Future<void> installModel() async {
    state = const AsyncLoading();

    final isConnected = await _connectivity.isConnected;
    if (!isConnected) {
      state = AsyncError(NetworkException(), StackTrace.current);
      return;
    }

    try {
      final isModelInstalled = await _gemmaClient.isModelInstalled();
      bool wasInstalled = false;
      if (!isModelInstalled) {
        wasInstalled = await _gemmaClient.installModel((p) {
          state = AsyncData(ModelrInstallInProgressState(progress: p));
        });
      }

      if (wasInstalled) {
        state = AsyncData(ModelInstalledState());
        return;
      }
      state = AsyncError(
        UnknownException,
        StackTrace.fromString(UnknownException().message),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final modelinstallProvider =
    AsyncNotifierProvider<ModelInstallNotifier, ModelInstallState>(
      ModelInstallNotifier.new,
    );
