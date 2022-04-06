import 'package:crud/pages/Items/items_page.dart';
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
    return ChangeNotifierProvider.value(
      value:AuthenticationService(),
      child: MaterialApp(
        title: 'Crud Assignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Auth(),
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = auth.currentUser;
    if (user != null) {
      print(user.email);
        return ItemsPage();
    }
    else {
      return LoginScreen();
    }

  }
}
