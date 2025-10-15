import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:statemanagement/home_test.dart';
import 'package:statemanagement/login_view.dart';

Future<void> handleFingerprintAuth(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GetStorage _storage = GetStorage();

  User? user = _auth.currentUser;
  bool fingerprintEnabled = _storage.read('fingerPrintKey') == true;

  if (user != null && fingerprintEnabled) {
    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Scan fingerprint to unlock the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('Fingerprint auth error: $e');
      authenticated = false;
    }

    if (authenticated) {
  
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeTest()),
      );
    } else {
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
    return;
  }

  if (user != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeTest()),
    );
    return;
  }

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const LoginView()),
  );
}
