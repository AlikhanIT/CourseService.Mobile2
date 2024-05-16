import 'package:dio/dio.dart';
import 'package:diploma/core/endpoints/endpoints.dart';
import 'package:diploma/data/models/login_response_model.dart';
import 'package:diploma/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

import '../../models/result.dart';
import 'api_provider.dart';

@singleton
class AuthApi extends ApiProvider {

  Future<Result<LoginResponseModel?>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await httpClient.post(query: Endpoints.login, data: {
        'username': username,
        'password': password,
      });

        return Result.success(data: LoginResponseModel.fromJson(response));
    }
    catch (e){
      print('Login error: $e');
      return Result.error(errorMessage: e.toString());
    }
  }

  Future<Result<LoginResponseModel?>> register({
    required String username,
    required String password
  }) async {
    try {
      var response = await httpClient.post(
          query: Endpoints.register,
          data: {
            'username': username,
            'password': password,
          }
      );
      return Result.success(data: LoginResponseModel.fromJson(response));
    }
    catch (e) {
      print("register failed $e");
      return Result.error(errorMessage: e.toString());
    }
  }

  Future<Result<UserModel?>> getUserInfo() async {
    try {
      var response = await httpClient.get(
          query: Endpoints.userInfo
      );
      return Result.success(data: UserModel.fromJson(response));
    }
    catch (e) {
      print("register failed $e");
      return Result.error(errorMessage: e.toString());
    }
  }
}
