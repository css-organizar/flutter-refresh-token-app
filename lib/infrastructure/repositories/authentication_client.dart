import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/session.dart';
import '../../domain/entities/authentication_response.dart';

import 'authentication_api.dart';

class AuthenticationClient {
  final FlutterSecureStorage _secureStorage;
  final AuthenticationAPI _authenticationAPI;

  Completer _completer;

  AuthenticationClient(this._secureStorage, this._authenticationAPI);

  void _complete() {
    if (_completer != null && !_completer.isCompleted) {
      _completer.complete();
    }
  }

  Future<String> get accessToken async {
    if (_completer != null) {
      await _completer.future;
    }

    _completer = Completer();

    final data = await _secureStorage.read(key: 'SESSION');
    if (data != null) {
      final session = Session.fromJson(jsonDecode(data));

      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDate.difference(createdAt).inSeconds;

      if (expiresIn - diff >= 60) {
        _complete();
        return session.token;
      }

      final response = await _authenticationAPI.refreshToken(session.token);
      if (response.data != null) {
        await this.saveSession(response.data);
        _complete();
        return response.data.token;
      }
      _complete();

      return null;
    }
    _complete();
    return null;
  }

  Future<void> saveSession(AuthenticationResponse authenticationResponse) async {
    final Session session = Session(
      token: authenticationResponse.token,
      expiresIn: authenticationResponse.expiresIn,
      createdAt: DateTime.now(),
    );

    final data = jsonEncode(session.toJson());
    await _secureStorage.write(key: 'SESSION', value: data);
  }

  Future<void> signOut() async {
    await _secureStorage.deleteAll();
  }
}
