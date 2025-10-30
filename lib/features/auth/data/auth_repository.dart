import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/auth_models.dart';

class AuthRepository {
  AuthRepository(this._ref)
      : _dio = _ref.read(dioProvider),
        _storage = const FlutterSecureStorage();

  final Ref _ref;
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _cookieKey = 'voz_session_cookie';
  static const _usernameKey = 'voz_username';

  Future<Session> login(String username, String password) async {
    final response = await _dio.post(
      '/login/login',
      data: FormData.fromMap({'login': username, 'password': password}),
    );
    final cookie = response.headers['set-cookie']?.join(';') ?? '';
    if (cookie.isEmpty) {
      throw Exception('Failed to acquire session cookie');
    }
    final session = Session(cookie: cookie, username: username);
    await _persistSession(session);
    return session;
  }

  Future<void> logout() async {
    await _dio.post('/logout');
    await _clearSession();
  }

  Future<Session?> getCurrentSession() async {
    final cookie = await _storage.read(key: _cookieKey);
    final username = await _storage.read(key: _usernameKey);
    if (cookie == null || username == null) {
      return null;
    }
    return Session(cookie: cookie, username: username);
  }

  Future<void> _persistSession(Session session) async {
    await _storage.write(key: _cookieKey, value: session.cookie);
    await _storage.write(key: _usernameKey, value: session.username);
  }

  Future<void> _clearSession() async {
    await _storage.delete(key: _cookieKey);
    await _storage.delete(key: _usernameKey);
  }
}
