import 'package:flutter/material.dart';
import 'package:job_app/pages/chatList_page.dart';

import '../services/auth/auth_service.dart';
// import '../pages/Chat_page.dart';
import '../pages/Setting_page.dart';
import '../pages/UserProfile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo

              UserAccountsDrawerHeader(
                accountName: const Text('Oflutter.com'),
                accountEmail: const Text('example@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
                ),
              ),

              //home list tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              // user profile list tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("P R O F I L E"),
                  leading: const Icon(Icons.account_circle),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                    //navigate to the user profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserProfile(),
                      ),
                    );
                  },
                ),
              ),

              // // chat page   tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("C H A T"),
                  leading: const Icon(Icons.message),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                    //navigate to the chat page
                  },
                ),
              ),

              // chatlist  tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("C H A T  L I S T"),
                  leading: const Icon(Icons.list),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                    //navigate to the chat page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatListPage(),
                      ),
                    );
                  },
                ),
              ),

              //setting list tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    //navigate to the setting page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout list tile

          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
