import 'package:flutter/material.dart';

class Uptextbox2 extends StatelessWidget {
  final String text;
  final String sectionName;

  const Uptextbox2({super.key, required this.text, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
      margin: const EdgeInsets.only(left: 20, right: 29, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
          //text
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
