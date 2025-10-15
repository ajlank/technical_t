import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:statemanagement/auth/firebase_auth.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  final authService = AuthService();
  String role = 'User'; 

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
    
        if (user.email != null && user.email!.toLowerCase() == 'admin@gmail.com') {
          role = 'Admin';
        } else {
          role = 'User';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome, $role!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await authService.logOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
