/// Events for the SignInBloc.
abstract class SignInEvent {
  const SignInEvent();
}

/// Event to trigger the sign in process.
class SignInSubmitted extends SignInEvent {
  const SignInSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}