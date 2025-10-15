import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:statemanagement/dialogs/handle_function.dart';
import 'package:statemanagement/home_test.dart';
import 'package:statemanagement/login_view.dart';
import 'package:statemanagement/sign_up.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:Home(),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const HomeTest(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final gs = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final hasFingerprint = gs.read('fingerPrintKey') == true;

    if (user != null || hasFingerprint) {
      return const HomeTest();
    } else {
      return const LoginView();
    }
  }
}
