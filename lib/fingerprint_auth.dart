import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:get_storage/get_storage.dart';

class FingerprintAuth {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GetStorage _storage = GetStorage();


  bool isFingerprintEnabled() {
    return _storage.read('fingerPrintKey') == true;
  }


  Future<bool> authenticate({String reason = 'Scan your fingerprint to continue'}) async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    bool isDeviceSupported = await _localAuth.isDeviceSupported();

    if (!canCheckBiometrics || !isDeviceSupported) {
      debugPrint('Device does not support biometric authentication.');
      return false;
    }

    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      debugPrint('Fingerprint auth error: $e');
      return false;
    }
  }

  Future<void> enableFingerprint() async {
    await _storage.write('fingerPrintKey', true);
  }

  Future<void> disableFingerprint() async {
    await _storage.remove('fingerPrintKey');
  }
}
