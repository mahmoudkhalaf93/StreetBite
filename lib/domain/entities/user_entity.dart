import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? profilePicUrl;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePicUrl,
  });

  @override
  List<Object?> get props => [uid, name, email, profilePicUrl];
}
