import 'package:flutter/material.dart';
import '../themes/light_mode.dart';





class MyTextField extends StatelessWidget {
  final String hinttext;
  final bool obsectext;
  final TextEditingController txtcontroller;
  final maxline;
  const MyTextField({super.key,
  required this.hinttext,required this.obsectext,
  required this.txtcontroller,required this.maxline,
  });

   @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: TextField(
      maxLines: maxline,
      obscureText: obsectext,
      controller: txtcontroller ,
decoration: InputDecoration(
  enabledBorder: OutlineInputBorder(
   
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
  ),
  //fillColor: Theme.of(context).colorScheme.primary,
  filled: true,
  hintText: hinttext,
  
  
)
    )
    );
    
    
    
  }

  
}

