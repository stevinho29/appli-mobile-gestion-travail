

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/models/user.dart';

class UserDao{
  String uid;
  UserDao(this.uid);

  final CollectionReference userCollection= Firestore.instance.collection("users");

  Future updateUserData(String name, String surname,String email,Map<String,String> address,int tel) async{
    return await userCollection.document(uid).setData({
      'uid': uid,
      'name':name,
      'surname': surname,
      'email': email,
      'address': address,
      'tel':tel,
      'findable': false,
      'createdAt': DateTime.now()
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
        tel: snapshot.data['tel']
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
// user list to hire from snapshot
   List<UserData> _HireListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.map((doc) {
      print(doc.data['name']);
      return UserData(
          uid: doc.data['uid'] ?? 'no uid',
          name: doc.data['name'] ?? 'no name',
          surname: doc.data['surname'] ?? 'no surname',
          email: doc.data['strength'] ?? 'no email',
          rue: doc.data['address']['rue'] ?? 'no address',
          codePostal: doc.data['address']['code_postal'] ?? 'no address',
          tel: doc.data['tel'] ?? 'no tel',
          findable: doc.data['findable'] ?? false,
          createdAt: doc.data['createdAt'] ?? DateTime(0000,00,00)
      );
    }).toList();
  }

   Future<List<UserData>>  hireableUser() async {

      QuerySnapshot qShot =await userCollection.where("uid",isEqualTo: uid).where("findable",isEqualTo: false).getDocuments();

      return qShot.documents.map(
              (doc) => UserData(
                  uid: doc.data['uid'] ?? 'no uid',
                  name: doc.data['name'] ?? 'no name',
                  surname: doc.data['surname'] ?? 'no surname',
                  email: doc.data['strength'] ?? 'no email',
                  rue: doc.data['address']['rue'] ?? 'no address',
                  codePostal: doc.data['address']['code_postal'] ?? 'no address',
                  tel: doc.data['tel'] ?? 'no tel',
                  findable: doc.data['findable'] ?? false,
                  createdAt: doc.data['createdAt'] ?? DateTime(0000,00,00)
              )).toList();

  }
Stream<QuerySnapshot> hireUser(){ // liste de personnes non trouvables

    return userCollection.where("findable",isEqualTo: false).snapshots();
}

  Stream<QuerySnapshot> specificHireableUser(String name){
    int pos= name.indexOf(" ");
    if(pos != -1) {
      print("en haut");
      List<String> nameList = name.split(" ");
      return userCollection.where("name",isEqualTo: nameList[0]).where("surname",isEqualTo: nameList[1]).where("findable",isEqualTo: true).snapshots();
    }
    else {
      print("en bas");
      Stream<QuerySnapshot> query= userCollection.where("name", isEqualTo: name).where("findable", isEqualTo: true).snapshots();
      query.listen((q) {
       print( "taille ${q.documents.length}");
      });
      return query;
    }
  }
}
