import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Validate NIC format
  bool validateNIC(String nic) {
    // NIC should contain either 12 numbers or 9 numbers ending with X or V
    return RegExp(r'^\d{9}[XV]$').hasMatch(nic) ||
        RegExp(r'^\d{12}$').hasMatch(nic);
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String username, String nic) async {
    try {
      // Check if username or NIC already exists
      final existingUser = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (existingUser.docs.isNotEmpty) {
        throw Exception('Username already exists.');
      }

      final existingNic = await _firestore
          .collection('users')
          .where('nic', isEqualTo: nic)
          .get();
      if (existingNic.docs.isNotEmpty) {
        throw Exception('NIC already exists.');
      }

      // Validate NIC format
      if (!validateNIC(nic)) {
        throw Exception('Invalid NIC format.');
      }

      // If username, NIC, and format are valid and unique, proceed with user registration
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store a demo picture URL for each user
      final demoPictureUrl = 'assets/profile.jpg';

      await _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'username': username,
          'nic': nic,
          'profileImageUrl': demoPictureUrl,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
