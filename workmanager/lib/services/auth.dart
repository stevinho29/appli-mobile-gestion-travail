import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_manager/models/user.dart';

import 'databases/userDao.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
Future signInWithRegisterAndPassword(String email, String password) async{
    try{
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e);
      return null;
    }
}

  // register with email and password
Future registerWithEmailAndPassword(String name,String surname,String email, String password) async{
    try{
      AuthResult result=await  _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
      await UserDao(user.uid).createUserData(name, surname,email); // on save le user dans la database
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e);
      return null;
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

  Future<bool> changePassword(String password) async{
    //Create an instance of the current user.
    FirebaseUser _user = await _firebaseAuth.currentUser();

    //Pass in the password to updatePassword.
    try{
      await _user.updatePassword(password);
      print("Succesfull changed password");
      return true;
    }catch(e)
    {
      print("Password can't be changed" + e.toString());
      return false;
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    }

  }
}