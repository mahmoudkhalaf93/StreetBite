import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.loginWithEmail(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}

class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return repository.signUpWithEmail(
      params.name,
      params.email,
      params.password,
    );
  }
}

class SignUpParams {
  final String name;
  final String email;
  final String password;
  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class GoogleSignInUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;
  GoogleSignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}

class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
