part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
    const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object?> get props => [error];
}