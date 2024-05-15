import 'dart:async';

abstract class BaseHttpClient {
  void clearToken();

  Future get({
    required query,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, String>? urlParameters,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int retryCount = 0,
  });

  Future post({
    required query,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, String>? urlParameters,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int retryCount = 0,
  });

  Future put(
      {required query,
      Map<String, dynamic>? data,
      Map<String, String>? urlParameters});

  Future patch(
      {required query,
      Map<String, dynamic>? data,
      Map<String, String>? urlParameters});

  Future delete(
      {required query,
      Map<String, dynamic>? data,
      Map<String, String>? urlParameters});

  void showLog(bool show);
}
