import 'package:flutter/material.dart';
import '../pages/colors.dart' as color;

class Uptextbox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const Uptextbox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

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
      padding: const EdgeInsets.only(left: 15, bottom: 15),
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

              //edit button
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.settings,
                    color: color.AppColor.gradientSecond,
                  ))
            ],
          ),
          //text
          Text(text),
        ],
      ),
    );
  }
}
