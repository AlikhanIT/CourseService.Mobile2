import 'package:bloc/bloc.dart';
import 'package:diploma/core/services/secure_storage/secure_storage.dart';
import 'package:diploma/data/api/auth_api.dart';
import 'package:diploma/data/models/user_model.dart';
import 'package:diploma/models/result.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';


@singleton
class AuthCubit extends Cubit<AuthState> {
  final AuthApi api;
  static String? accessToken;
  SecureStorage storage;

  AuthCubit(this.api, this.storage) : super(AuthInitial());

  register({required String username, required String password}) async {
    try {
      emit(AuthLoading());

      final loginResponseModel =
       await api.register(username: username, password: password);

      if (loginResponseModel.isSuccess &&
          loginResponseModel.data?.accessToken != null && loginResponseModel.data?.refreshToken != null) {
        await storage.write("access_token", loginResponseModel.data!.accessToken!);
        await storage.write("access_token", loginResponseModel.data!.refreshToken!);
        getUserInfo();
      }
    } catch (e) {
      // rethrow;
    }
  }

  login({required String username, required String password}) async {
    try {
      emit(AuthLoading());

      final loginResponseModel =
          await api.login(username: username, password: password);
      if (loginResponseModel.isSuccess &&
          loginResponseModel.data?.accessToken != null && loginResponseModel.data?.refreshToken != null) {
        accessToken = loginResponseModel.data!.accessToken!;
        await storage.write("access_token", loginResponseModel.data!.accessToken!);
        await storage.write("access_token", loginResponseModel.data!.refreshToken!);
        getUserInfo();
      }
    } catch (e) {
      // rethrow;
    }
  }

  Future<Result<UserModel?>> getUserInfo() async {
    final result = await api.getUserInfo();
    if (result.isSuccess) {
      return Result.success(data: result.data);
    }
    return Result.error(errorMessage: "");
  }

  Future logout() async {
    await storage.remove("access_token");
  }
  Future
  doNothing() async {}
}
