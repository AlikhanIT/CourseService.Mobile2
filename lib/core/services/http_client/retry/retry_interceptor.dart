
import 'package:dio/dio.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final Dio dio;
  final int retryCount;
  RetryOnConnectionChangeInterceptor({
    required this.dio,
    required this.retryCount,
  });

  @override
  Future<dynamic> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      await Future.delayed(2 as Duration);
      err.requestOptions.extra = {
        'retry_count': (err.requestOptions.extra['retry_count'] ?? 0) + 1
      };
      err.requestOptions.extra = {
        'retry_count': (err.requestOptions.extra['retry_count'] ?? 0) + 1
      };
      err.requestOptions.connectTimeout = 10 as Duration?;
      err.requestOptions.receiveTimeout = 10 as Duration?;
      try {
        await dio
            .fetch<void>(err.requestOptions)
            .then((value) => handler.resolve(value));
      } on DioException catch (e) {
        super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return [500].contains(err.response?.statusCode) ||
        (err.requestOptions.extra['retry_count'] ?? 0) < 3;
  }
}
