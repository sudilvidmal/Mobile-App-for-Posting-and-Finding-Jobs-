import 'package:flutter/material.dart';
import '../pages/colors.dart' as color;

class Uptextbox2 extends StatelessWidget {
  final String text;
  final String sectionName;

  const Uptextbox2({super.key, required this.text, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 10,
            color: color.AppColor.homePageTitle.withOpacity(0.15),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
      margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                    color: color.AppColor.gradientFirst,
                    fontWeight: FontWeight.w500),
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
