import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../infrastructure/repositories/account_api.dart';
import '../../../infrastructure/repositories/authentication_api.dart';
import '../../../infrastructure/repositories/authentication_client.dart';
import '../helpers/http.dart';

abstract class DependencyInjection {
  static void initialize() {
    final Dio dio = Dio(
      BaseOptions(baseUrl: 'https://curso-api-flutter.herokuapp.com'),
    );

    Http http = Http(
      dio: dio,
      logsEnabled: true,
    );

    final secureStorage = FlutterSecureStorage();

    final authenticationAPI = AuthenticationAPI(http);
    final authenticationClient = AuthenticationClient(secureStorage, authenticationAPI);
    final accountAPI = AccountAPI(http, authenticationClient);

    GetIt.instance.registerSingleton<AuthenticationAPI>(authenticationAPI);
    GetIt.instance.registerSingleton<AuthenticationClient>(authenticationClient);
    GetIt.instance.registerSingleton<AccountAPI>(accountAPI);
  }
}
