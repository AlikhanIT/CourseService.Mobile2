import 'package:diploma/core/endpoints/endpoints.dart';
import 'package:diploma/data/models/login_response_model.dart';
import 'package:injectable/injectable.dart';

import 'api_provider.dart';

@singleton
class AuthApi extends ApiProvider {

  Future<LoginResponseModel?> login({
    required String username,
    required String password,
  }) async {
    try {
      dynamic response = await httpClient.post(query: Endpoints.login, data: {
        'username': username,
        'password': password,
      });
      print(response.status);
      final res = LoginResponseModel.fromJson(response);
      return res;
    }
    catch (e){
      print(e);
    }
    return null;
  }

  Future<LoginResponseModel> register({
    required String username,
    required String password
  }) async {
    var response = await httpClient.post(
      query: Endpoints.register,
      data: {
        'username': username,
        'password': password,
      }
    );
    final res = LoginResponseModel.fromJson(response);
    return res;
  }

}
