import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../storage_service.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Generate username from email by taking the part before @ and removing any trailing numbers
  String _generateUsername(String email) {
    // Get the part before '@'
    String prefix = email.split('@')[0];
    // Remove any trailing numbers
    return prefix.replaceAll(RegExp(r'\d+$'), '');
  }

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      //sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // fetch user data from firestore
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();
      
      if (userDoc.exists) {
        String name = userDoc.get('name') ?? _generateUsername(email);
        // save email and name to local storage
        await _storage.saveString('user_email', email);
        await _storage.saveString('user_name', name);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password, {String? name}) async {
    try {
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save email to local storage
      await _storage.saveString('user_email', email);

      // Determine the name to save
      String finalName = (name != null && name.isNotEmpty) 
          ? name 
          : _generateUsername(email);
      
      await _storage.saveString('user_name', finalName);

      //save user info
      await _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'name': finalName,
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    // clear local storage
    await _storage.remove('user_email');
    await _storage.remove('user_name');
    
    return await _auth.signOut();
  }
}
