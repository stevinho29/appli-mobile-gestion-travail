

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/models/user.dart';

class UserDao{
  String uid;
  UserDao(this.uid);

  final CollectionReference userCollection= Firestore.instance.collection("users");

  Future updateUserData(String name, String surname,String email,Map<String,String> address,int tel,bool findable) async{
    return await userCollection.document(uid).setData({
      'uid': uid,
      'name':name,
      'surname': surname,
      'email': email,
      'address': address,
      'tel':tel,
      'findable': findable,
    });
  }

  Future createUserData(String name, String surname,String email) async{

    return await userCollection.document(uid).setData({
      'uid':uid,
      'name':name,
      'surname': surname,
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
        tel: snapshot.data['tel'],
        findable: snapshot.data['findable'],
        createdAt: DateTime(0000,00,00) //DateTime.fromMillisecondsSinceEpoch(snapshot.data['createdAt'])

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
        .map(_HireListFromSnapshot);
}

// get current user data
  Future<UserData> getUserData ()  async{
      DocumentSnapshot d= await userCollection.document(uid).get();
      return _userDataFromSnapchot(d);
  }
// user list to hire from snapshot
   List<UserData> _HireListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.map((doc) {
      print(doc.data['name']);
      return UserData(
          uid: doc.data['uid'] ?? 'no uid',
          name: doc.data['name'] ?? 'no name',
          surname: doc.data['surname'] ?? 'no surname',
          email: doc.data['email'] ?? 'no email',
          rue: doc.data['address']['rue'] ?? 'no address',
          codePostal: doc.data['address']['code_postal'] ?? 'no address',
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
                  rue: doc.data['address']['rue'] ?? 'no address',
                  codePostal: doc.data['address']['code_postal'] ?? 'no address',
                  tel: doc.data['tel'] ?? 'no tel',
                  findable: doc.data['findable'] ?? false,
                  createdAt: DateTime(0000,00,00)
              )).toList();

  }
Future<Stream<List<UserData>>> hireUser() async { // liste de personnes non trouvables

    //return userCollection.where("findable",isEqualTo: false).snapshots();
}

  Future<QuerySnapshot> specificHireableUser(String name){  // utilisé
    int pos= name.indexOf(" ");
    if(pos != -1) {
      print("en haut");
      List<String> nameList = name.split(" ");
      print(nameList[1]);
      Future<QuerySnapshot> query= userCollection.where("name", isEqualTo: nameList[0]).where("surname",isEqualTo: nameList[1]).where("findable",isEqualTo: true).getDocuments();
      query.then((q) {
        print( "taille ${q.documents.length}");
      });
      return query;
    }
    else {
      print("en bas");
      Future<QuerySnapshot> query= userCollection.where("name", isEqualTo: name).where("findable", isEqualTo: true).getDocuments();
      query.then((q) {
       print( "taille ${q.documents.length}");
      });
      return query;
    }
  }
}
