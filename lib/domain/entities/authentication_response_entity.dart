import 'package:meta/meta.dart' show required;

class AuthenticationResponseEntity {
  final String token;
  final int expiresIn;

  AuthenticationResponseEntity({
    @required this.token,
    @required this.expiresIn,
  });

  static AuthenticationResponseEntity fromJson(Map<String, dynamic> json) {
    return AuthenticationResponseEntity(
      token: json['token'],
      expiresIn: json['expiresIn'],
    );
  }
}
