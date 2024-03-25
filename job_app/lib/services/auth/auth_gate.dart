import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/services/auth/login_or_register.dart';

import '../../pages/home_page.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in

          if (snapshot.hasData) {
            return HomePage(); //const
          }

          //user is Not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
