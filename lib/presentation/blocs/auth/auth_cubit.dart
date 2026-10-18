import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.googleSignInUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.props.first as String)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    emit(AuthLoading());
    final result = await signUpUseCase(
      SignUpParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.props.first as String)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await googleSignInUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.props.first as String)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> logOut() async {
    emit(AuthLoading());
    final result = await signOutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.props.first as String)),
      (_) => emit(AuthInitial()), // Logged out
    );
  }
}
