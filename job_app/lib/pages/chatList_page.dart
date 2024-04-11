import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobee/pages/Chat_page.dart';
import 'package:jobee/services/auth/auth_service.dart';
import 'package:jobee/services/chat/chat_service.dart';

import '../components/user_tile.dart';

class ChatListPage extends StatelessWidget {
  ChatListPage({Key? key});

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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error fetching users");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Map<String, dynamic>>? userDataList =
            snapshot.data as List<Map<String, dynamic>>?;

        if (userDataList == null) {
          return const Text("No user data available");
        }

        final List<Map<String, dynamic>> filteredUserDataList = userDataList
            .where((userData) =>
                userData["email"] != _authService.getCurrentUser()?.email)
            .toList();

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView.builder(
            itemCount: filteredUserDataList.length,
            itemBuilder: (context, index) {
              final userData = filteredUserDataList[index];
              final String receiverUsername = userData["username"] ?? '';
              final String receiverBio = userData["bio"] ?? '';
              final String profileImageUrl = userData["profileImageUrl"] ?? '';
              final String receiverID = userData["uid"] ?? '';

              return StreamBuilder(
                stream: _chatService.getMessages(
                  _authService.getCurrentUser()!.uid,
                  receiverID,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Error fetching messages");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  final List<DocumentSnapshot> messageList =
                      snapshot.data?.docs ?? [];
                  final bool hasMessages = messageList.isNotEmpty;

                  if (!hasMessages) {
                    return const SizedBox.shrink();
                  }

                  final List<Map<String, dynamic>> chatHistory = messageList
                      .map((documentSnapshot) =>
                          documentSnapshot.data() as Map<String, dynamic>)
                      .toList();

                  return UserTile(
                    text: receiverUsername,
                    text2: receiverBio,

                    profileImageUrl: profileImageUrl, // Pass profile image URL
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverUsername: receiverUsername,
                            receiverID: receiverID,
                            senderID: _authService.getCurrentUser()!.uid,
                            chatHistory: chatHistory,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
