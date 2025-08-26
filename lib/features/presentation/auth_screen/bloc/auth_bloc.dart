import 'package:chef_ai/core/utils/app_logger_helper.dart';
import 'package:chef_ai/features/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<SignOutRequested>(_onSignOutRequested);
    // on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  // Sign In Event Handler
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      AppLoggerHelper.info('User logged in: ${result.user?.uid}');

      final user = result.user;
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthFailure(error: 'User data not available'));
      }
    } on FirebaseAuthException catch (e) {
      String message = _getFirebaseAuthErrorMessage(e.code);
      AppLoggerHelper.error('FirebaseAuth error: ${e.code} - $message');
      emit(AuthFailure(error: message));
    } catch (e) {
      AppLoggerHelper.error('Unexpected error: $e');
      emit(const AuthFailure(error: 'Something went wrong. Please try again.'));
    }
  }

  // Sign Up Event Handler
  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await result.user?.updateDisplayName(event.name);

      // Create user model and save to Firestore
      final userModel = UserModel(
        email: event.email,
        name: event.name,
        profilePicUrl: null,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(result.user?.uid).set({
        ...userModel.toMap(),
      });

      AppLoggerHelper.info('User signed up: ${result.user?.uid}');

      final user = result.user;
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(const AuthFailure(error: 'User data not available'));
      }
    } on FirebaseAuthException catch (e) {
      String message = _getSignUpErrorMessage(e.code);
      AppLoggerHelper.error('FirebaseAuth error: ${e.code} - $message');
      emit(AuthFailure(error: message));
    } catch (e) {
      AppLoggerHelper.error('Unexpected error: $e');
      emit(const AuthFailure(error: 'Something went wrong. Please try again.'));
    }
  }

  // Reset Password Event Handler
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: event.email);
      AppLoggerHelper.info('Password reset email sent to ${event.email}');
      emit(const AuthSuccess(user: null));
    } on FirebaseAuthException catch (e) {
      String message = _getResetPasswordErrorMessage(e.code);
      AppLoggerHelper.error('FirebaseAuth error: ${e.code} - $message');
      emit(AuthFailure(error: message));
    } catch (e) {
      AppLoggerHelper.error('Unexpected error: $e');
      emit(const AuthFailure(error: 'Something went wrong. Please try again.'));
    }
  }

  // Sign Out Event Handler
  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      AppLoggerHelper.info('User signed out successfully');
      emit(AuthInitial());
    } on FirebaseAuthException catch (e) {
      String message = _getSignOutErrorMessage(e.code);
      AppLoggerHelper.error('FirebaseAuth error: ${e.code} - $message');
      emit(AuthFailure(error: message));
    } catch (e) {
      AppLoggerHelper.error('Unexpected error signing out: $e');
      emit(const AuthFailure(error: 'Failed to sign out. Please try again.'));
    }
  }

  // Google Sign In Event Handler
  // Future<void> _onGoogleSignInRequested(
  //   GoogleSignInRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoading());
  //   try {
  //     // Ensure GoogleSignIn is initialized
  //     await _googleSignIn.initialize();

  //     // Sign out first to force account picker
  //     await _googleSignIn.signOut();

  //     // Check if authenticate is supported
  //     if (_googleSignIn.supportsAuthenticate()) {
  //       // final GoogleSignInAccount? googleUser =
  //       //     await _googleSignIn.authenticate();

  //       // if (googleUser == null) {
  //       //   emit(const AuthFailure(error: 'Google sign in was cancelled'));
  //       //   return;
  //       // }

  //       // // Get auth tokens
  //       // final GoogleSignInAuthentication googleAuth =
  //       //     await googleUser.authentication;

  //       // // Build Firebase credential
  //       // final credential = GoogleAuthProvider.credential(
  //       //   idToken: googleAuth.idToken,
  //       // );

  //       // // Sign in with Firebase
  //       // final result = await _auth.signInWithCredential(credential);
  //       // AppLoggerHelper.info('Google user logged in: ${result.user?.uid}');

  //       // final user = result.user;
  //     //   if (user != null) {
  //     //     emit(AuthSuccess(user: user));
  //     //   } else {
  //     //     emit(const AuthFailure(error: 'Google user data not available'));
  //     //   }
  //     // } else {
  //     //   emit(const AuthFailure(error:
  //     //     'This platform does not support Google Sign-In authentication'));
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     AppLoggerHelper.error('FirebaseAuth Google error: ${e.code} - ${e.message}');
  //     emit(AuthFailure(error: e.message ?? 'Google sign in failed'));
  //   } catch (e) {
  //     AppLoggerHelper.error('Google Sign-In error: $e');
  //     emit(const AuthFailure(error: 'Google sign in failed. Please try again.'));
  //   }
  // }

  // Helper method for Sign In error messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'The password is incorrect.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is disabled.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }

  // Helper method for Sign Up error messages
  String _getSignUpErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return 'An unknown error occurred.';
    }
  }

  // Helper method for Reset Password error messages
  String _getResetPasswordErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return 'An unknown error occurred. Please try again.';
    }
  }

  // Helper method for Sign Out error messages
  String _getSignOutErrorMessage(String code) {
    switch (code) {
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      case 'requires-recent-login':
        return 'You need to re-authenticate before signing out.';
      default:
        return 'An unknown error occurred while signing out.';
    }
  }
}
