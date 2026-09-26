import 'dart:convert';
import 'dart:math';

import 'package:bunpod/bunpod.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Signs in with Google or Apple through Firebase and returns its ID token.
class SocialSignInService {
  const SocialSignInService();

  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;

  Future<SocialSignInResult> signIn(AuthProvider provider) {
    return switch (provider) {
      AuthProvider.google => _signInWithGoogle(),
      AuthProvider.apple => _signInWithApple(),
    };
  }

  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }

  Future<SocialSignInResult> _signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      clientId: defaultTargetPlatform == .iOS
          ? AppConfig.googleIosClientId
          : null,
      serverClientId: AppConfig.googleServerClientId,
    );

    late final GoogleSignInAccount account;

    try {
      account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const SocialSignInCancelled();
      }

      rethrow;
    }

    final String? googleIdToken = account.authentication.idToken;

    if (googleIdToken == null) {
      throw Exception('Google did not return an ID token');
    }

    return _exchange(
      AuthProvider.google,
      GoogleAuthProvider.credential(idToken: googleIdToken),
    );
  }

  Future<SocialSignInResult> _signInWithApple() async {
    // Apple gets the hashed nonce, Firebase verifies the raw one.
    final String rawNonce = _generateNonce();

    late final AuthorizationCredentialAppleID appleCredential;

    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: _sha256(rawNonce),
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const SocialSignInCancelled();
      }

      rethrow;
    }

    final OAuthCredential credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Apple only sends the name on first sign-in, so save it to Firebase.
    final String? appleName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ').trim().nullIfEmpty;

    return _exchange(AuthProvider.apple, credential, appleName: appleName);
  }

  Future<SocialSignInResult> _exchange(
    AuthProvider provider,
    AuthCredential credential, {
    String? appleName,
  }) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithCredential(credential);

    User? user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase returned no user for ${provider.name}');
    }

    if (appleName != null && (user.displayName?.isEmpty ?? true)) {
      await user.updateDisplayName(appleName);
      await user.reload();
      user = _firebaseAuth.currentUser ?? user;
    }

    // Refresh so the token includes the new display name.
    final String? idToken = await user.getIdToken(appleName != null);

    if (idToken == null) {
      throw Exception('Firebase returned no ID token');
    }

    return SocialSignInResult(
      provider: provider,
      idToken: idToken,
      uid: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  String _generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();

    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
