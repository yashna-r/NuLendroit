import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'databaseService.dart';

//class Auth implements AuthImplementation{
class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in with email and password
  Future<String> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      return user.uid;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future<String> signUp(String email, String password) async {
    try {

      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      await DatabaseService(userId: user.uid).updateUserData(user.uid, 'New user', 'General', [], '');
      return user.uid;

    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//  Future<String> getCurrentUser() async{
////    FirebaseUser user = await _auth.currentUser();
////    return user.uid;
////  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}