import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

final authGuardProvider = ChangeNotifierProvider<AuthGuard>((ref) {
  final notifier = AuthGuard(ref);
  ref.listen<AuthState>(authStateProvider, (_, __) => notifier._notify());
  return notifier;
});

class AuthGuard extends ChangeNotifier {
  AuthGuard(this.ref);

  final Ref ref;

  bool get isAuthenticated => ref.read(authStateProvider).maybeMap(
        authenticated: (_) => true,
        orElse: () => false,
      );

  void _notify() {
    notifyListeners();
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.unauthenticated());

  final AuthRepository _repository;

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    try {
      final session = await _repository.login(username, password);
      state = AuthState.authenticated(session);
    } catch (e) {
      state = AuthState.failure(e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }
}
