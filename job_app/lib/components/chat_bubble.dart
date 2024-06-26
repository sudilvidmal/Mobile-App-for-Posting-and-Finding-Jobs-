import 'package:flutter/material.dart';
import 'package:jobee/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/colors.dart' as color;

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    //light vs darkmode chatbuuble colors
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode
                ? color.AppColor.gradientSecond
                : color.AppColor.gradientSecond)
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(
            color: isCurrentUser
                ? Colors.white
                : isDarkMode
                    ? Colors.white
                    : Colors.black),
      ),
    );
  }
}
