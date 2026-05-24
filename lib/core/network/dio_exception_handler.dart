import 'package:ai_health_companion/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

extension DioExceptionMappable on DioException {
  CustomException toCustomException() {
    final wrapped = error;
    if (wrapped is CustomException) return wrapped;

    return switch (type) {
      DioExceptionType.connectionError => const NetworkException(),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => const TimeOutExceptiopn(),

      DioExceptionType.badResponse => ServerException(
        message: 'HTTP ${response?.statusCode}',
        statusCode: response?.statusCode,
      ),

      _ => UnknownException(message: message ?? 'Unknown Dio error'),
    };
  }
}
