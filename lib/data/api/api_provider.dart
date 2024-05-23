import 'package:injectable/injectable.dart';

import '../../core/services/http_client/http_client.dart';
import '../../core/services/http_client/http_client_base.dart';

@singleton
class ApiProvider {
  static const url = 'http://10.0.2.2:5001';

  BaseHttpClient httpClient = MHttpClient(baseUrl: url);
}