import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:statemanagement/auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
final authService = AuthService();
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  
Future<void> login() async {
  try {
    final bool? isLoggedIn = await authService.login(
      _email.text.trim(),
      _password.text.trim(),
      context,
    );

    if (isLoggedIn == true && mounted) {
     
      final bool? enable = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Fingerprint auth"),
          content: const Text("Do you want to enable fingerprint for faster login next time?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
            ),
          ],
        ),
      );

      
      if (enable == true) {
        await authService.promptFingerprintEnable(context);
      }else{
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false,);
      }
      
      
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Please try again.")),
        );
      }
    }
  } catch (e) {
    print("Error during login: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                        keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email...',
                      ),
                    ),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        hintText: 'Enter your password....',
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 50,
                      width: 100,

                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () async{
                          await login();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/signup', (_) => false,);
                      },
                      child: const Text('Not registered yet? register here'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
