import 'package:flutter/material.dart';
import 'package:job_app/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home"),
      ),
      drawer: const MyDrawer(),
    );
  }
}
