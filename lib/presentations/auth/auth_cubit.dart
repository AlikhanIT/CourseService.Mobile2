import 'package:bloc/bloc.dart';
import 'package:diploma/core/services/secure_storage/secure_storage.dart';
import 'package:diploma/data/api/auth_api.dart';
import 'package:diploma/data/models/login_response_model.dart';
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

      LoginResponseModel loginResponseModel =
       await api.register(username: username, password: password);

    } catch (e) {
      // rethrow;
    }
  }

  login({required String username, required String password}) async {
    try {
      emit(AuthLoading());

      final loginResponseModel =
          await api.login(username: username, password: password);

    } catch (e) {
      // rethrow;
    }
  }

  Future doNothing() async {}
}
