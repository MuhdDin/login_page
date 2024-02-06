import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(String emailAddress, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      final user = credential.user;
      String uid = credential.user!.uid;
      await user?.sendEmailVerification();
      return uid;
    } on FirebaseAuthException catch (e) {
      print('Full Details: $e');
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return '';
    } catch (e) {
      print('Unexpected error: $e');
      return '';
    }
  }

  Future<List> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;

      if (user != null && user.emailVerified) {
        return [true, 'success'];
      } else if (!user!.emailVerified) {
        return [false, 'email is not verified'];
      } else {
        return [false, 'email not signed in yet'];
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      return [false, e.code];
    } catch (e) {
      print('Unexpected error: $e');
      return [false, e];
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
