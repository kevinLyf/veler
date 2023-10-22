import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    if (!(await auth.canCheckBiometrics) || !(await auth.isDeviceSupported()))
      return false;

    try {
      return await auth.authenticate(
        localizedReason: "Confirm Authentication",
        authMessages: const [
          AndroidAuthMessages(
            cancelButton: "Cancel",
            signInTitle: "Biometric Validation",
            biometricHint: "",
          ),
          IOSAuthMessages(
            cancelButton: "Cancel",
            lockOut: "",
            localizedFallbackTitle: "",
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (err) {
      debugPrint(err.toString());
      return false;
    }
    return false;
  }
}