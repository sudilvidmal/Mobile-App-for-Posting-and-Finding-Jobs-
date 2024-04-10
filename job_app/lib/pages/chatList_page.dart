// ignore: file_names
import 'package:flutter/material.dart';
import 'package:jobee/pages/Chat_page.dart';
import 'package:jobee/services/auth/auth_service.dart';
import 'package:jobee/services/chat/chat_service.dart';

// import '../components/my_drawer.dart';
import '../components/user_tile.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({super.key});

  //chat auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "Chat List",
          style: TextStyle(
            fontSize: 20, // Adjust the font size as needed
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
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
        print(snapshot
            .connectionState); // Print the connection state of the stream
        print(snapshot.error); // Print any error received from the stream
        // Handle different snapshot states based on your requirements
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
        text: userData["username"],
        onTap: () {
          //tapped on the user go to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUsername: userData["username"],
                receiverID: userData["uid"],
                senderID: "email",
                chatHistory: [],
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
