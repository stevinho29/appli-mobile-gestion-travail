import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/models/user.dart';

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
Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result=await  _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
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
}