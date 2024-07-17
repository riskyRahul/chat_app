// ignore_for_file: unused_local_variable, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuth {
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    //login_type.value = 'A';
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ],
          nonce: nonce);
      print(appleCredential.authorizationCode);
      final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken, rawNonce: rawNonce);
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';
      final firebaseUser = authResult.user;
      //await firebaseUser!.updateProfile(displayName: displayName);
      //await firebaseUser.updateEmail(userEmail);
      return firebaseUser!;
    } catch (e) {
      print(e);
    }
  }
}
