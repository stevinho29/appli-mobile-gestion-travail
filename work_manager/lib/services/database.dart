

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/models/user.dart';

class DatabaseService{
  String uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection= Firestore.instance.collection("users");

  Future updateUserData(String name, String surname,String email,Map<String,String> address,int tel) async{
    return await userCollection.document(uid).setData({
      'uid': uid,
      'name':name,
      'surname': name,
      'email': email,
      'address': address,
      'tel':tel
    });
  }

  Future createUserData(String name, String surname,String email) async{
    return await userCollection.document(uid).setData({
      'uid':uid,
      'name':name,
      'surname': name,
      'email': email
    });
  }

  // user data from snapshot
  UserData _userDataFromSnapchot(DocumentSnapshot snapshot){
    return UserData(  // light version of constructor without the birthDate
        uid: uid,
        name: snapshot.data['name'] ?? 'no name',
        surname: snapshot.data['surname'] ?? 'no surname',
        email: snapshot.data['email'] ?? 'no email',
        rue: snapshot.data['address']['rue'],
        codePostal: snapshot.data['address']['code_postal'],
        tel: snapshot.data['tel']
    );
  }
  //get user data stream
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots()
        .map(_userDataFromSnapchot);
  }
}