import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:jobee/components/text_box_ui.dart';
import 'package:jobee/components/text_box_ui2.dart';
import 'package:image_picker/image_picker.dart';




class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final usersCollection = FirebaseFirestore.instance.collection("users");

  bool _isImagePickerActive = false; // Flag to track if image picker is active
  bool _isUploadingImage = false; // Flag to track if image is being uploaded

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit your $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter your new $field here!",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser!.uid).update({field: newValue});
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a reference to the Firebase Storage bucket
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      setState(() {
        _isUploadingImage = true;
      });

      // Get the download URL of the uploaded file
      String imageUrl = await (await uploadTask).ref.getDownloadURL();

      setState(() {
        _isUploadingImage = false;
      });

      // Return the download URL as a string
      return imageUrl;
    } catch (e) {
      // Handle any errors that occur during the upload process
      print('Error uploading image to Firebase Storage: $e');
      // Return an empty string or null to indicate failure
      return '';
    }
  }

  File? _image;

  void _selectAndUploadImage() async {
    // Check if image picker is already active
    if (_isImagePickerActive) {
      return;
    }

    setState(() {
      _isImagePickerActive = true;
    });

    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _isImagePickerActive = false;
    });

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Save Image?'),
          content: Text('Do you want to save this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final imageUrl = await uploadImageToFirebase(_image!);

                  if (imageUrl.isNotEmpty) {
                    await usersCollection
                        .doc(currentUser!.uid)
                        .update({'profileImageUrl': imageUrl});
                    print('Image uploaded successfully!');
                  } else {
                    print('Failed to upload image: imageUrl is empty');
                  }
                } catch (e) {
                  print('Error uploading image to Firebase Storage: $e');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent navigation if image is being uploaded
        if (_isUploadingImage) {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent dismissing the dialog by tapping outside
            builder: (context) => AlertDialog(
              title: Text('Please wait'),
              content: Text('Please wait until the image is uploading.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
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
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.data() == null) {
              return Center(child: Text("No user data found"));
            } else {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final profileImageUrl = userData['profileImageUrl'];

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(height: 40),
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _image != null
                              ? Image.file(_image!).image
                              : (profileImageUrl != null
                                  ? NetworkImage(profileImageUrl as String)
                                  : const NetworkImage(
                                      'https://images.pexels.com/photos/8885094/pexels-photo-8885094.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1')),
                          // Use a default image if profileImageUrl is null
                        ),
                        _isUploadingImage
                            ? CircularProgressIndicator() // Show loading indicator while uploading image
                            : Container(),
                        Positioned(
                          bottom: 0,
                          right: 135,
                          child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt_rounded),
                                color: Colors.grey[700],
                                iconSize: 20,
                                onPressed: _selectAndUploadImage,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Hello, ' + (userData['username'] ?? ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18, // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      "View & Edit Details",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Uptextbox(
                    text: userData['bio'],
                    sectionName: 'Biography',
                    onPressed: () => editField('bio'),
                  ),
                  Uptextbox2(
                    text: userData['nic'],
                    sectionName: 'My NIC',
                  ),
                  Uptextbox2(
                    text: userData['email'],
                    sectionName: 'My E-mail',
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
