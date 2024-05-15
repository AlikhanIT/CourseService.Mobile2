// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import '../../../presentations/auth/auth_cubit.dart';
import 'http_client_base.dart';

class MHttpClient extends _HttpClient {
  MHttpClient({
    required String baseUrl,
  }) : super(
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 200),
              receiveTimeout: const Duration(seconds: 200),
              headers: {
                "contentType": "application/json",
              },
            ),
          ),
        );
}

class _HttpClient implements BaseHttpClient {
  final Dio _dio;
  static const defaultRetryCount = 3;
  bool _showLog = true;
  bool canRefresh = true;

  _HttpClient(
    this._dio,
  ) {
    _setInterceptors();
  }

  @override
  void showLog(bool show) => _showLog = show;

  @override
  void clearToken() => AuthCubit.accessToken = null;

  static String urlWithParams(String url, Map<String, String>? params) {
    if (params != null) {
      params.forEach((key, value) => url = url.replaceAll(key, value));
    }
    return url;
  }

  @override
  Future get({
    required query,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, String>? urlParameters,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int retryCount = 0,
  }) async {
    return await _sendRequest(_dio.get(
      urlWithParams(query, urlParameters),
      queryParameters: queryParameters,
      options: _optionsBuilder(
        headers: headers,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        retryCount: retryCount,
      ),
    ));
  }

  @override
  Future post({
    required query,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, String>? urlParameters,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int retryCount = 0,
  }) async {
    var a = 0;
    return await _sendRequest(
      _dio.post(
        urlWithParams(query, urlParameters),
        data: data,
        options: _optionsBuilder(
          headers: headers,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          retryCount: retryCount,
        ),
      ),
    );
  }

  @override
  Future put({
    required query,
    Map<String, dynamic>? data,
    Map<String, String>? urlParameters,
  }) async {
    return await _sendRequest(
      _dio.put(urlWithParams(query, urlParameters), data: data),
    );
  }

  @override
  Future patch({
    required query,
    Map<String, dynamic>? data,
    Map<String, String>? urlParameters,
  }) async {
    return await _sendRequest(
      _dio.patch(urlWithParams(query, urlParameters), data: data),
    );
  }

  @override
  Future delete({
    required query,
    Map<String, dynamic>? data,
    Map<String, String>? urlParameters,
  }) async {
    return await _sendRequest(
      _dio.delete(urlWithParams(query, urlParameters), data: data),
    );
  }

  Future _sendRequest(Future<Response> request) async {
    final Response response = await request;
    final result = response.data;
    return result ?? false;
  }

  Future<void> _setInterceptors() async {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (object) {
          debugPrint('retry------------------------- $object');
        },
        // specify log function (optional)
        retries: defaultRetryCount,
        retryDelays: [
          const Duration(seconds: 1),
          const Duration(seconds: 5),
          const Duration(seconds: 10),
        ],
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // if (AuthCubit.accessToken != null) {
          //   options.headers["Authorization"] =
          //       "Bearer ${AuthCubit.accessToken!}";
          // }
          // print('body ${options.data}');
          // options.headers["contentType"] = 'application/json';
          // options.headers["X-Otbasybank-Resource"] = '5';
          //'Accept-Language': 'ru-RU', //'kk-KZ'

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        }
      ),
    );
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Options _optionsBuilder(
      {Map<String, dynamic>? headers,
      Duration? connectTimeout,
      Duration? receiveTimeout,
      int retryCount = 0}) {
    final options = Options(
      headers: headers,
      sendTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    //Be sure that in using library ro_attempt key didnt changed
    int attemptNumber = defaultRetryCount - retryCount;
    if (attemptNumber < 0) attemptNumber = 0;
    if (options.extra == null) {
      options.extra = {'ro_attempt': attemptNumber};
    } else {
      options.extra?['ro_attempt'] = attemptNumber;
    }
    return options;
  }

// Future<void> refreshToken() async {
//   //accessToken = await _storage.readRefreshToken();
//   final responseData = await _sendRequest(
//     _dio.post("/auth/token/refresh"),
//   );
//   canRefresh = true;
//   AuthCubit.accessToken = responseData["access"];
// }
}
