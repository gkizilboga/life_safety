import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/bina_store.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// Triggers Google Sign-In and updates BinaStore
  static Future<GoogleSignInAccount> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.authenticate();
      // Sync user data to local storage
      BinaStore.instance.userName = account.displayName ?? "Misafir";
      BinaStore.instance.isRegistered = true;
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Handles manual email login (Simulated/Local only)
  static Future<void> signInWithEmail(String email, {String? name}) async {
    // If name is provided, use it. Otherwise fallback to email prefix.
    if (name != null && name.trim().isNotEmpty) {
      BinaStore.instance.userName = name.trim();
    } else {
      BinaStore.instance.userName = email.split('@')[0];
    }
    BinaStore.instance.isRegistered = true;
  }

  /// Logs out from Google and local session
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    BinaStore.instance.isRegistered = false;
  }
}
