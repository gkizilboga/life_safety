import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/bina_store.dart';

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Triggers Google Sign-In and updates BinaStore
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        // Sync user data to local storage
        BinaStore.instance.userName = account.displayName ?? "Misafir";
        BinaStore.instance.isRegistered = true;
        // We could store email too if BinaStore supported it
        await BinaStore.instance.saveToDisk(immediate: true);
      }
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Handles manual email login (Simulated/Local only)
  static Future<void> signInWithEmail(String email) async {
    // In a real app without Firebase, this might call a custom API.
    // Here we just accept the email and mark the user as registered.
    BinaStore.instance.userName = email.split('@')[0]; // Simple nickname
    BinaStore.instance.isRegistered = true;
    await BinaStore.instance.saveToDisk(immediate: true);
  }

  /// Logs out from Google and local session
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    BinaStore.instance.isRegistered = false;
    await BinaStore.instance.saveToDisk(immediate: true);
  }
}
