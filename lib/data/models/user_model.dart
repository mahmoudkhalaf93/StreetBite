import '../../domain/entities/user_entity.dart';

// Applying the Builder Design Pattern as requested in the project requirements
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.profilePicUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicUrl: json['profilePicUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
    };
  }
}

class UserModelBuilder {
  String? _uid;
  String? _name;
  String? _email;
  String? _profilePicUrl;

  UserModelBuilder setUid(String uid) {
    _uid = uid;
    return this;
  }

  UserModelBuilder setName(String name) {
    _name = name;
    return this;
  }

  UserModelBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserModelBuilder setProfilePicUrl(String? profilePicUrl) {
    _profilePicUrl = profilePicUrl;
    return this;
  }

  UserModel build() {
    if (_uid == null || _name == null || _email == null) {
      throw Exception('Missing required fields to build UserModel');
    }
    return UserModel(
      uid: _uid!,
      name: _name!,
      email: _email!,
      profilePicUrl: _profilePicUrl,
    );
  }
}
