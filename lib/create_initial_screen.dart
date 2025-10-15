import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GetStorage _storage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkFingerprintOnLaunch();
  }

  Future<void> _checkFingerprintOnLaunch() async {
    bool? fingerprintEnabled = _storage.read('fingerPrintKey');
    User? user = _auth.currentUser;
    if (user != null && fingerprintEnabled == true) {
      try {
        bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Scan fingerprint to unlock',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (authenticated) {
          // Fingerprint success -> go to home
          Navigator.of(context).pushReplacementNamed('/home');
          return;
        } else {
          // Fingerprint failed -> fallback to login
          Navigator.of(context).pushReplacementNamed('/login');
          return;
        }
      } catch (e) {
        // Any error during fingerprint -> fallback to login
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
    }

    // If user is logged in but fingerprint is not enabled
    if (user != null && fingerprintEnabled != true) {
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    }
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
