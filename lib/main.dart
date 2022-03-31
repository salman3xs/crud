import 'package:crud/pages/login_page.dart';
import 'package:crud/Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = auth.currentUser;
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_)=>AuthenticationService(),
        ),
        StreamProvider(create: (context)=> context.read<AuthenticationService>().authStateChanges, initialData: user,)
      ],
      child: MaterialApp(
        title: 'Crud Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
