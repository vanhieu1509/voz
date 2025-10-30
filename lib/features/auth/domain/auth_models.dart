import 'package:equatable/equatable.dart';

class Session extends Equatable {
  const Session({required this.cookie, required this.username});

  final String cookie;
  final String username;

  @override
  List<Object?> get props => [cookie, username];
}

abstract class AuthState {
  const AuthState();

  T when<T>({
    required T Function() unauthenticated,
    required T Function() loading,
    required T Function(Session session) authenticated,
    required T Function(String message) failure,
  });

  T maybeMap<T>({
    T Function(Unauthenticated value)? unauthenticated,
    T Function(Loading value)? loading,
    T Function(Authenticated value)? authenticated,
    T Function(Failure value)? failure,
    required T Function() orElse,
  });

  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(Session session) = Authenticated;
  const factory AuthState.failure(String message) = Failure;
}

class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  T when<T>({
    required T Function() unauthenticated,
    required T Function() loading,
    required T Function(Session session) authenticated,
    required T Function(String message) failure,
  }) {
    return unauthenticated();
  }

  @override
  T maybeMap<T>({
    T Function(Unauthenticated value)? unauthenticated,
    T Function(Loading value)? loading,
    T Function(Authenticated value)? authenticated,
    T Function(Failure value)? failure,
    required T Function() orElse,
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

class Loading extends AuthState {
  const Loading();

  @override
  T when<T>({
    required T Function() unauthenticated,
    required T Function() loading,
    required T Function(Session session) authenticated,
    required T Function(String message) failure,
  }) {
    return loading();
  }

  @override
  T maybeMap<T>({
    T Function(Unauthenticated value)? unauthenticated,
    T Function(Loading value)? loading,
    T Function(Authenticated value)? authenticated,
    T Function(Failure value)? failure,
    required T Function() orElse,
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

class Authenticated extends AuthState {
  const Authenticated(this.session);

  final Session session;

  @override
  T when<T>({
    required T Function() unauthenticated,
    required T Function() loading,
    required T Function(Session session) authenticated,
    required T Function(String message) failure,
  }) {
    return authenticated(session);
  }

  @override
  T maybeMap<T>({
    T Function(Unauthenticated value)? unauthenticated,
    T Function(Loading value)? loading,
    T Function(Authenticated value)? authenticated,
    T Function(Failure value)? failure,
    required T Function() orElse,
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

class Failure extends AuthState {
  const Failure(this.message);

  final String message;

  @override
  T when<T>({
    required T Function() unauthenticated,
    required T Function() loading,
    required T Function(Session session) authenticated,
    required T Function(String message) failure,
  }) {
    return failure(message);
  }

  @override
  T maybeMap<T>({
    T Function(Unauthenticated value)? unauthenticated,
    T Function(Loading value)? loading,
    T Function(Authenticated value)? authenticated,
    T Function(Failure value)? failure,
    required T Function() orElse,
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}
