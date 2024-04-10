import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobee/pages/job_page.dart';
import 'package:jobee/pages/job_publish.dart';
import 'package:jobee/services/auth/login_or_register.dart';

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
             return Job_Page();
            //return HomePage(); //const
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
