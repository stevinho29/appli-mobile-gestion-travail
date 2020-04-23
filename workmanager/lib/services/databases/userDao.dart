

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/user.dart';

class UserDao{
  String uid;
  UserDao(this.uid);

  final CollectionReference userCollection= Firestore.instance.collection("users");

  Future updateUserData(Map<String,String> address,int tel) async{
    return await userCollection.document(uid).updateData({
      'address': address,
      'tel':tel,
    });
  }
Future updateUserDataWithToken(String token,String platform){
    Map<String,String> tok= new Map();
    tok['token']= token;
    tok['platform']= platform;
    try{
   return userCollection.document(uid).updateData({
      'token':tok,
    });
    }catch(e){
      print(e);
      return null;
    }
}
  Future createUserData(String name, String surname,String email) async{
      Map<String,String> address= new Map();
      address['address']= "null";
      address['code_postal']= "null";
    return await userCollection.document(uid).setData({
      'uid':uid,
      'name':name,
      'surname': surname,
      'email': email,
      'address': address ,
       'tel': 0,
      'findable':true,
      'createdAt': DateTime.now()
    });
  }

  // user data from snapshot
  UserData _userDataFromSnapchot(DocumentSnapshot snapshot){
    var millis= snapshot.data['createdAt'];

    print("GET USER Time TEST ${DateTime.fromMillisecondsSinceEpoch(millis.millisecondsSinceEpoch)}");
    return UserData(
        uid: snapshot.data['uid'] ?? 'no uid',
        name: snapshot.data['name'] ?? 'no name',
        surname: snapshot.data['surname'] ?? 'no surname',
        email: snapshot.data['email'] ?? 'no email',
        address: snapshot.data['address']['address'] ?? "null",
        codePostal: snapshot.data['address']['code_postal'] ?? "null",
        tel: snapshot.data['tel'] ?? 0,
        findable: snapshot.data['findable'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(millis.millisecondsSinceEpoch) ?? DateTime.now() //DateTime.fromMillisecondsSinceEpoch(snapshot.data['createdAt'])

    );
  }
  //get user data stream
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots()
        .map(_userDataFromSnapchot);
  }

  //get user to hire data stream
 Stream<List<UserData>> get userTohireData{
    return userCollection.where("uid",isEqualTo: uid).where("findable",isEqualTo: false).snapshots()
        .map(_hireListFromSnapshot);
}

// get current user data
  Future<UserData> getUserData ()  async{
      DocumentSnapshot d= await userCollection.document(uid).get();
      return _userDataFromSnapchot(d);
  }
// user list to hire from snapshot
   List<UserData> _hireListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.map((doc) {
      print(doc.data['uid']);
      return UserData(
          uid: doc.data['uid'] ?? 'no uid',
          name: doc.data['name'] ?? 'no name',
          surname: doc.data['surname'] ?? 'no surname',
          email: doc.data['email'] ?? 'no email',
          address: doc.data['address']['address'] ?? "null",
          codePostal: doc.data['address']['code_postal'] ?? "null",
          tel: doc.data['tel'] ?? 'no tel',
          findable: doc.data['findable'] ?? false,
          createdAt: doc.data['createdAt'] ?? DateTime(0000,00,00)
      );
    }).toList();
  }

   List<UserData>  hireableUserFromQshot(QuerySnapshot qShot)  {  // utilisé

      print("TAILLE ${qShot.documents.length}");
      return qShot.documents.map(
              (doc) => UserData(
                  uid: doc.data['uid'] ?? 'no uid',
                  name: doc.data['name'] ?? 'no name',
                  surname: doc.data['surname'] ?? 'no surname',
                  email: doc.data['email'] ?? 'no email',
                  address: doc.data['address']['address'] ?? 'no address',
                  codePostal: doc.data['address']['code_postal'] ?? 'no address',
                  tel: doc.data['tel'] ?? 'no tel',
                  findable: doc.data['findable'] ?? false,
                  createdAt: DateTime(0000,00,00)
              )).toList();

  }



  Future<List<UserData>> specificHireableUser(String name){  // utilisé
    name= name.trim();  // remove any leading or trailing caracter
    int pos= name.indexOf(" ");
    if(pos != -1) {
      print("en haut");
      List<String> nameList = name.split(" ");
      print(nameList[1]);
      return userCollection.where("name", isEqualTo: nameList[0]).where("surname",isEqualTo: nameList[1]).where("findable",isEqualTo: true).getDocuments().then((qShot) {
        print( "taille ${qShot.documents.length}");
      return  qShot.documents.map(_userDataFromSnapchot).toList();
      });

    }
    else {
      print("en bas");
      return userCollection.where("name", isEqualTo: name).where("findable", isEqualTo: true).getDocuments().then((qShot) {
       print( "taille ${qShot.documents.length}");
       return qShot.documents.map(_userDataFromSnapchot).toList();
      });

    }
  }
}
