import 'package:bloc/bloc.dart';
import 'package:diploma/core/services/secure_storage/secure_storage.dart';
import 'package:diploma/data/api/auth_api.dart';
import 'package:diploma/data/models/user_model.dart';
import 'package:diploma/models/result.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final AuthApi api;
  static String? accessToken;
  SecureStorage storage;

  AuthCubit(this.api, this.storage) : super(AuthInitial());

  Future<bool> register({required String username, required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final loginResponseModel = await api.register(username: username, email: email, password: password);

      if (loginResponseModel.isSuccess &&
          loginResponseModel.data?.accessToken != null &&
          loginResponseModel.data?.refreshToken != null) {
        accessToken = loginResponseModel.data!.accessToken!;
        await storage.write("access_token", loginResponseModel.data!.accessToken!);
        await storage.write("refresh_token", loginResponseModel.data!.refreshToken!);
        await getUserInfo();
        return true;
      } else {
        emit(AuthError("Ошибка регистрации"));
        return false;
      }
    } catch (e) {
      emit(AuthError("Ошибка регистрации: ${e.toString()}"));
      return false;
    } finally {
      emit(AuthInitial());
    }
  }

  Future<bool> login({required String username, required String password}) async {
    try {
      emit(AuthLoading());
      final loginResponseModel = await api.login(username: username, password: password);
      if (loginResponseModel.isSuccess &&
          loginResponseModel.data?.accessToken != null &&
          loginResponseModel.data?.refreshToken != null) {
        accessToken = loginResponseModel.data!.accessToken!;
        await storage.write("access_token", loginResponseModel.data!.accessToken!);
        await storage.write("refresh_token", loginResponseModel.data!.refreshToken!);
        await getUserInfo();
        return true;
      } else {
        emit(AuthError("Ошибка авторизации"));
        return false;
      }
    } catch (e) {
      emit(AuthError("Ошибка авторизации: ${e.toString()}"));
      return false;
    } finally {
      emit(AuthInitial());
    }
  }

  Future<Result<UserModel?>> getUserInfo() async {
    final result = await api.getUserInfo();
    if (result.isSuccess) {
      // Save user info in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.data!.role != null) await prefs.setString('role', result.data!.role);
      if (result.data!.id != null) await prefs.setString('id', result.data!.id);
      if (result.data!.email != null) await prefs.setString('email', result.data!.email);

      emit(AuthAuthenticated(result.data!));
      return Result.success(data: result.data);
    }
    return Result.error(errorMessage: "Не удалось получить информацию о пользователе");
  }

  Future<void> logout() async {
    await storage.remove("access_token");
    await storage.remove("refresh_token");
    accessToken = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await prefs.remove('id');
    await prefs.remove('email');

    emit(AuthLoggedOut());
  }

  Future<Map<String, String?>> getUserDetailsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    String? id = prefs.getString('id');
    String? email = prefs.getString('email');

    return {
      'role': role,
      'id': id,
      'email': email,
    };
  }
}
