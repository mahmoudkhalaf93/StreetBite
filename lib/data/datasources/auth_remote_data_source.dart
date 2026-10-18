import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String name, String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async {
    UserCredential? credential;
    try {
      // 1. Create user in Firebase Auth
      credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw AuthException(message: 'Failed to create user.');

      // Update display name
      await user.updateDisplayName(name);

      // 2. Build User Model using the Builder Pattern
      final userModel = UserModelBuilder()
          .setUid(user.uid)
          .setName(name)
          .setEmail(email)
          .build();

      // 3. Save user data to Firestore
      await firestore.collection('users').doc(user.uid).set(userModel.toJson());

      return userModel;
    } catch (e) {
      // ROLLBACK LOGIC: If Firestore fails or connection drops, delete the Auth account
      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (_) {
          // Ignore rollback errors, we just try our best to clean up
        }
      }

      if (e is FirebaseAuthException) {
        throw AuthException(message: _getFriendlyErrorMessage(e.code));
      } else {
        throw ServerException(message: 'Connection error. Please try again.');
      }
    }
  }

  @override
  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw AuthException(message: 'Login failed.');

      // Fetch user profile from Firestore
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      } else {
        // Fallback if Firestore doc is missing for some reason
        return UserModelBuilder()
            .setUid(user.uid)
            .setName(user.displayName ?? 'User')
            .setEmail(user.email ?? email)
            .build();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw ServerException(message: 'Connection error. Please try again.');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException(message: 'Google sign in aborted.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) throw AuthException(message: 'Google sign in failed.');

      // Check if user exists in Firestore, if not create them
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      } else {
        final newUserModel = UserModelBuilder()
            .setUid(user.uid)
            .setName(user.displayName ?? 'Google User')
            .setEmail(user.email ?? '')
            .setProfilePicUrl(user.photoURL)
            .build();

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(newUserModel.toJson());
        return newUserModel;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _getFriendlyErrorMessage(e.code));
    } catch (e) {
      throw ServerException(message: 'Connection error. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      throw ServerException(message: 'Failed to sign out.');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromJson(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      throw ServerException(message: 'Failed to get current user.');
    }
  }

  String _getFriendlyErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication failed. Please try again later.';
    }
  }
}
