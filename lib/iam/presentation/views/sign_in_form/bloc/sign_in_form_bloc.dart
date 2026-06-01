import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/iam/application/iam_facade_service.dart';
import 'package:restock/iam/presentation/views/sign_in_form/bloc/sign_in_form_event.dart';
import 'package:restock/iam/presentation/views/sign_in_form/bloc/sign_in_form_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';

/// BLoC for handling sign in logic.
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required this.authFacadeService}) : super(const SignInState()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  final AuthFacadeService authFacadeService;

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    try {
      final auth = await authFacadeService.signIn(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(status: Status.success, auth: auth));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        message: 'Invalid email or password',
      ));
    }
  }
}