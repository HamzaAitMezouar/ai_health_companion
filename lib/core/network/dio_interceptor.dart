import 'package:dio_smart_retry/dio_smart_retry.dart';

class RetryDioInterceptor extends RetryInterceptor {
  RetryDioInterceptor({required super.dio})
    : super(
        retries: 2,
        retryDelays: [const Duration(seconds: 2), const Duration(seconds: 5)],
        retryableExtraStatuses: {500, 502, 503},
      );
}
