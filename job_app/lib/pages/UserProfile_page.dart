import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/services/auth/auth_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _authService = AuthService();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 75,
                          backgroundImage: FileImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage('asstes/profile.jpg'),
                        ),
                  IconButton(
                    onPressed: () async {
                      String userId = _authService.getCurrentUser()!.uid;
                      String? imageUrl;
                      if (_image != null) {
                        final storageRef = FirebaseStorage.instance
                            .ref()
                            .child('profiles/$userId.jpg');
                        try {
                          await storageRef.putFile(_image!);
                          imageUrl = await storageRef.getDownloadURL();
                        } catch (e) {
                          print('Error uploading file: $e');
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .set(
                              {
                            'description': _descriptionController.text,
                            'profileImageUrl': imageUrl,
                          },
                              SetOptions(
                                  merge:
                                      true)); // Use merge option to merge with existing data
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Profile updated successfully.'),
                      ));
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String userId = _authService.getCurrentUser()!.uid;
                String? imageUrl;
                if (_image != null) {
                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('profiles/$userId.jpg');
                  try {
                    await storageRef.putFile(_image!);
                    imageUrl = await storageRef.getDownloadURL();
                  } catch (e) {
                    print('Error uploading file: $e');
                  }
                }
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                  'description': _descriptionController.text,
                  'profileImageUrl': imageUrl,
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Profile updated successfully.'),
                ));
              },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_authService.getCurrentUser()!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('User data not found.'));
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final imageUrl = userData['profileImageUrl'] as String?;
                  final description = userData['description'] as String?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null)
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                      SizedBox(height: 10),
                      if (description != null)
                        Text(
                          'Description: $description',
                          style: TextStyle(fontSize: 18),
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
