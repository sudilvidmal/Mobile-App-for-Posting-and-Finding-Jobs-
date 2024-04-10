import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _cachedUsername; // Username cache

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String getCachedUsername() {
    return _cachedUsername;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      print('Error getting user by email: $e');
      return null;
    }
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

      // Store the username in the cache
      _cachedUsername = username;

      // Store a demo picture URL for each user
      final demoPictureUrl =
          'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg';

      await _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'username': username,
          'nic': nic,
          'profileImageUrl': demoPictureUrl,
          'bio': 'Please update your bio!'
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
