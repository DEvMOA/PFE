import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUpUser(
    String fullName,
    String email,
    int phoneNumber,
    String password,
    String confirmPassword,
  ) async {
    try {
      if (passwordConfirmed(password, confirmPassword)) {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        addUserDetails(fullName, email, phoneNumber);
      }
    } catch (e) {
      //print(e);
    }
  }

  Future addUserDetails(String fullName, String email, int number) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'full name': fullName,
      'email': email,
      'number': number,
      'imageUrl': "",
      'uid': FirebaseAuth.instance.currentUser!.uid
    });
  }

  bool passwordConfirmed(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }
}
