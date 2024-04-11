import 'package:flutter/material.dart';
import '../pages/colors.dart' as color;

class UserTile extends StatelessWidget {
  final String text;
  final String text2;
  final String profileImageUrl; // Add profile image URL parameter
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.text2,
    required this.profileImageUrl, // Add profile image URL parameter
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10,
              color: color.AppColor.homePageTitle.withOpacity(0.15),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
        padding: EdgeInsets.only(top: 20, left: 30, bottom: 20, right: 30),
        child: Row(
          children: [
            // Profile image
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profileImageUrl),
            ),

            const SizedBox(width: 20),

            // user name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user name
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color.AppColor.gradientFirst,
                  ),
                ),
                // Add SizedBox for spacing between text1 and text2
                SizedBox(height: 4),
                // Second text below the first one
                Text(
                  text2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: color.AppColor.homePageTitle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
