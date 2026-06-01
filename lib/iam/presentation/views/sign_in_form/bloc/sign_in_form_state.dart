import 'package:restock/iam/domain/entities/auth.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// State for the SignInBloc.
class SignInState {
  const SignInState({
    this.status = Status.initial,
    this.auth,
    this.message,
  });

  final Status status;
  final Auth? auth;
  final String? message;

  SignInState copyWith({
    Status? status,
    Auth? auth,
    String? message,
  }) {
    return SignInState(
      status: status ?? this.status,
      auth: auth ?? this.auth,
      message: message ?? this.message,
    );
  }
}