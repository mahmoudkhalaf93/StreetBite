import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List<dynamic> properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure({this.message = 'Server Failure'});

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure({this.message = 'Cache Failure'});

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;
  const AuthFailure({this.message = 'Authentication Failure'});

  @override
  List<Object?> get props => [message];
}
