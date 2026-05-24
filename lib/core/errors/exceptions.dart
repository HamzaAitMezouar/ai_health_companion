sealed class CustomException implements Exception {
  final String message;
  const CustomException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends CustomException {
  final int? statusCode;
  const ServerException({required String message, this.statusCode})
    : super(message);
}

final class NetworkException extends CustomException {
  const NetworkException({String message = 'No internet connection.'})
    : super(message);
}

final class TimeOutExceptiopn extends CustomException {
  const TimeOutExceptiopn({String message = 'TimeOut'}) : super(message);
}

final class UnknownException extends CustomException {
  const UnknownException({String message = 'An unexpected error occurred.'})
    : super(message);
}

class EnvironmentException extends CustomException {
  const EnvironmentException({
    String message = 'Missing required environment variable ',
  }) : super(message);
}
