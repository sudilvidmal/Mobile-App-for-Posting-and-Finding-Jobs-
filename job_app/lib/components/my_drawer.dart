import 'package:flutter/material.dart';
import 'package:jobee/pages/chatList_page.dart';
import '../services/auth/auth_service.dart';
import '../pages/job_page.dart';
import '../pages/Setting_page.dart';
import '../pages/UserProfile_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String username = '';
  late String email = '';
  late String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final userData = await AuthService().getUserData(user.uid);
      if (userData != null) {
        setState(() {
          username = userData['username'];
          email = userData['email'];
          profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  void logout() {
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
              UserAccountsDrawerHeader(
                accountName: Text(
                  username,
                  style: TextStyle(color: Colors.white), // Set text color
                ),
                accountEmail: Text(
                  email,
                  style: TextStyle(color: Colors.white), // Set text color
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(
                      0.7), // Update background color and make it blur
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://static.vecteezy.com/system/resources/previews/004/947/449/non_2x/coniferous-twigs-closeup-dark-nature-background-realistic-pine-or-spruce-branches-on-blurred-background-lush-vegetation-in-a-coniferous-forest-copy-space-illustration-vector.jpg',
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text("H O M E"),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("P R O F I L E"),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("C H A T"),
                leading: const Icon(Icons.list),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("S E T T I N G S"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("V I E W  J O B S"),
                leading: const Icon(Icons.settings),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobPage(),
                    ),
                  );
                },
              ),
            ],
          ),
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
