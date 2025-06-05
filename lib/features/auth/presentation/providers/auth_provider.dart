import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/services/hive_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user_entity.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user provider
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserEntity?>>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  CurrentUserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _init() async {
    final user = HiveService.getCurrentUser();
    if (user != null) {
      state = AsyncValue.data(user.toEntity());
    } else {
      state = const AsyncValue.data(null);
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _handleUserSignIn(credential.user!);
      }
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_getAuthErrorMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error('An unexpected error occurred', StackTrace.current);
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password, String displayName) async {
    try {
      state = const AsyncValue.loading();
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await _handleUserSignUp(credential.user!, displayName);
      }
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_getAuthErrorMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error('An unexpected error occurred', StackTrace.current);
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = const AsyncValue.data(null);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _handleUserSignIn(userCredential.user!);
      }
    } catch (e) {
      state = AsyncValue.error('Google sign-in failed', StackTrace.current);
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await HiveService.clearUser();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error('Sign out failed', StackTrace.current);
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete user data from Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        
        // Delete user transactions
        final transactionsQuery = await _firestore
            .collection('transactions')
            .where('userId', isEqualTo: user.uid)
            .get();
        
        for (final doc in transactionsQuery.docs) {
          await doc.reference.delete();
        }
        
        // Clear local data
        await HiveService.clearAllData();
        
        // Delete Firebase user
        await user.delete();
        
        state = const AsyncValue.data(null);
      }
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_getAuthErrorMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error('Failed to delete account', StackTrace.current);
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? preferredCurrency,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final currentUserModel = HiveService.getCurrentUser();
      if (currentUserModel == null) return;

      // Update Firebase user profile
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore document
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (preferredCurrency != null) updateData['preferredCurrency'] = preferredCurrency;
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Update local storage
      final updatedUser = currentUserModel.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        preferredCurrency: preferredCurrency,
      );
      
      await HiveService.saveUser(updatedUser);
      state = AsyncValue.data(updatedUser.toEntity());
    } catch (e) {
      state = AsyncValue.error('Failed to update profile', StackTrace.current);
    }
  }

  // Handle user sign in
  Future<void> _handleUserSignIn(User firebaseUser) async {
    try {
      // Get or create user document in Firestore
      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      UserModel userModel;
      if (userDoc.exists) {
        userModel = UserModel.fromJson(userDoc.data()!);
        userModel = userModel.copyWith(
          lastLoginAt: DateTime.now(),
          fcmToken: await NotificationService.getFirebaseToken(),
        );
      } else {
        userModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
          phoneNumber: firebaseUser.phoneNumber,
          emailVerified: firebaseUser.emailVerified,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          fcmToken: await NotificationService.getFirebaseToken(),
        );
      }

      // Update Firestore
      await _firestore.collection('users').doc(firebaseUser.uid).set(
        userModel.toJson(),
        SetOptions(merge: true),
      );

      // Save to local storage
      await HiveService.saveUser(userModel);
      
      state = AsyncValue.data(userModel.toEntity());
    } catch (e) {
      state = AsyncValue.error('Failed to process user data', StackTrace.current);
    }
  }

  // Handle user sign up
  Future<void> _handleUserSignUp(User firebaseUser, String displayName) async {
    try {
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: displayName,
        photoUrl: firebaseUser.photoURL,
        phoneNumber: firebaseUser.phoneNumber,
        emailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        fcmToken: await NotificationService.getFirebaseToken(),
      );

      // Save to Firestore
      await _firestore.collection('users').doc(firebaseUser.uid).set(userModel.toJson());

      // Save to local storage
      await HiveService.saveUser(userModel);
      
      state = AsyncValue.data(userModel.toEntity());
    } catch (e) {
      state = AsyncValue.error('Failed to create user profile', StackTrace.current);
    }
  }

  // Get auth error message
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}

// Auth form validation providers
final emailValidationProvider = StateProvider<String?>((ref) => null);
final passwordValidationProvider = StateProvider<String?>((ref) => null);
final confirmPasswordValidationProvider = StateProvider<String?>((ref) => null);

// Validation functions
String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Please confirm your password';
  }
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}

String? validateDisplayName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Name is required';
  }
  if (name.length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}