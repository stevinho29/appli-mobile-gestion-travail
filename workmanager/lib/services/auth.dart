import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_manager/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'databases/userDao.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid): null ;
  }

  // auth change user stream
  Stream<User> get user{
    return _firebaseAuth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user))
        .map((_userFromFirebaseUser));
  }

  // sign in anon
Future signInAnon() async{
  try{
   AuthResult result= await _firebaseAuth.signInAnonymously();
   FirebaseUser user = result.user;
   return _userFromFirebaseUser(user);
  }catch(e){
    print(e);
    return null;
  }
}
  // sign in with email and password
Future<int> signInWithRegisterAndPassword(String email, String password) async{
    try{
       await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      //FirebaseUser user= result.user;
      return 0;
    }catch(e){
      print(e);
      if(e.toString().contains("ERROR_WRONG_PASSWORD"))
        return 1;
      else if(e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if(e.toString().contains("ERROR_USER_NOT_FOUND"))
        return 3;
      else if(e.toString().contains("ERROR_USER_DISABLED"))
        return 4;
      else if(e.toString().contains("ERROR_TOO_MANY_REQUESTS"))
        return 5;
      else if(e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 6;
      else
        return 7;
    }
}

  // register with email and password
Future<int> registerWithEmailAndPassword(String name,String surname,String email, String password) async{
    try{
      AuthResult result=await  _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
      await UserDao(user.uid).createUserData(name, surname,email); // on save le user dans la database
      String fcmToken = await _fcm.getToken();
      await UserDao(user.uid).updateUserDataWithToken(fcmToken, Platform.operatingSystem);  // on save le token
      return 0;
    }catch(e){
      print(e);
      if(e.toString().contains("ERROR_WEAK_PASSWORD"))
        return 1;
      else if(e.toString().contains("ERROR_INVALID_EMAIL"))
        return 2;
      else if(e.toString().contains("ERROR_EMAIL_ALREADY_IN_USE"))
        return 3;
      else if(e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 4;
      else
        return 5;
    }
}

// send reset password link
  Future sendResetPasswordLink(String email) async {
    try{
       await _firebaseAuth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e);
      return null;
    }
  }
  //sign out
  Future signOut() async{
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<int> changePassword(String password) async{
    //Create an instance of the current user.
    FirebaseUser _user = await _firebaseAuth.currentUser();

    //Pass in the password to updatePassword.
    try{
      await _user.updatePassword(password);
      print("Succesfully changed password");
      return 0;
    }catch(e)
    {
      print("Password can't be changed" + e.toString());
      if(e.toString().contains("ERROR_REQUIRES_RECENT_LOGIN"))
        return 1;
      else if(e.toString().contains("ERROR_WEAK_PASSWORD"))
        return 2;
      else if(e.toString().contains("ERROR_USER_DISABLED"))
        return 3;
      else if(e.toString().contains("ERROR_NETWORK_REQUEST_FAILED"))
        return 4;
      else
        return 5;
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    }

  }
}