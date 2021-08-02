import 'package:meta/meta.dart' show required;

import '../../application/commons/helpers/http.dart';
import '../../application/commons/helpers/http_response.dart';
import '../../domain/entities/authentication_response_entity.dart';

class AuthenticationAPI {
  final Http _http;

  AuthenticationAPI(this._http);

  Future<HttpResponse<AuthenticationResponseEntity>> register({
    @required String username,
    @required String email,
    @required String password,
  }) {
    return _http.request<AuthenticationResponseEntity>(
      '/api/v1/register',
      method: "POST",
      data: {
        "username": username,
        "email": email,
        "password": password,
      },
      parser: (data) {
        return AuthenticationResponseEntity.fromJson(data);
      },
    );
  }

  Future<HttpResponse<AuthenticationResponseEntity>> login({
    @required String email,
    @required String password,
  }) async {
    return _http.request<AuthenticationResponseEntity>(
      '/api/v1/login',
      method: "POST",
      data: {
        "email": email,
        "password": password,
      },
      parser: (data) {
        return AuthenticationResponseEntity.fromJson(data);
      },
    );
  }

  Future<HttpResponse<AuthenticationResponseEntity>> refreshToken(String expiredToken) {
    return _http.request<AuthenticationResponseEntity>(
      '/api/v1/refresh-token',
      method: "POST",
      headers: {
        "token": expiredToken,
      },
      parser: (data) {
        return AuthenticationResponseEntity.fromJson(data);
      },
    );
  }
}
