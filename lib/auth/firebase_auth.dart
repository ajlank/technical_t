import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> signUp(String email, String pass, BuildContext context) async {
    try {
     await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final user=_auth.currentUser;

      if(user!=null){
      if(context.mounted){
               Navigator.of(context).pushNamedAndRemoveUntil('/login',(_)=>false);
      }else{
        return;
      }
      }
    } on FirebaseAuthException catch (e) {
      print("SignUp Error: ${e.message}");
    }
  }

 Future<bool?> login(String email, String pass, BuildContext context) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: pass);
    final user = _auth.currentUser;

    if (user != null) {
      String role = email.toLowerCase() == 'admin@gmail.com' ? 'admin' : 'normal';
      await GetStorage().write('userRole', role); 

      if (context.mounted) return true;
      return true;
    } else {
      return false;
    }
  } on FirebaseAuthException catch (e) {
    print("Login Error: ${e.message}");
    return null;
  }
}


  Future<void> promptFingerprintEnable(BuildContext context) async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your device not supported for the biometric authentication')));
    }

    bool didAuthenticate = await _localAuth.authenticate(
      localizedReason: 'Confirm fingerprint to enable quick login',
      options: const AuthenticationOptions(biometricOnly: true),
    );
   
    if (!didAuthenticate) {
      await GetStorage().write('fingerPrintKey',true);
      Navigator.of(context).pushNamedAndRemoveUntil('/home',(route) => false,);
    }
   
  }

  Future<void>logOut()async{
    try{
      await _auth.signOut();
      
    }catch(e){
      print(e.toString());
    }
  }
}
