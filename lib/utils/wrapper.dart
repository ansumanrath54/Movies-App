import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/homepage.dart';
import 'package:movie_app/pages/login.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

    Widget welcomeMessage(context) {
      Future.delayed(const Duration(seconds: 0), () {
        String name = user!.displayName.toString();
        var snackBar = SnackBar(
          content: Text("Welcome back!  $name"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.whenComplete(() => ScaffoldMessenger.of(context).clearSnackBars());
      });
      return const HomePage();
    }

  @override
  Widget build(BuildContext context) {
    return user != null ? welcomeMessage(context) : const LoginPage();
  }
}
