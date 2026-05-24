abstract class ModelInstallState {}

class ModelNotInstalledState extends ModelInstallState {}

class ModelrInstallInProgressState extends ModelInstallState {
  int? progress;
  ModelrInstallInProgressState({required this.progress});
}

class ModelInstalledState extends ModelInstallState {}
