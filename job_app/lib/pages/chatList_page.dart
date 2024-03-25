import 'package:flutter/material.dart';
import 'package:job_app/pages/Chat_page.dart';
import 'package:job_app/services/auth/auth_service.dart';
import 'package:job_app/services/chat/chat_service.dart';

// import '../components/my_drawer.dart';
import '../components/user_tile.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  //caht auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat List"),
      ),
      // drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build a list of users exept for the current logged in user

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all user exept current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on the user go to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
