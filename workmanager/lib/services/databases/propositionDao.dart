
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/proposition.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/services/databases/userDao.dart';

class PropositionDao{

  String uid;
  PropositionDao({this.uid});

  final CollectionReference propositionCollection= Firestore.instance.collection("propositions");


  Future updatePropositionData(Proposition propositionData,String libelle,int price,Map<String,DateTime> dat) async {
    try{
        return propositionCollection.document(propositionData.documentId).updateData({
          'libelle': libelle,
          'price':price,
          'sendDate': DateTime.now(),
          'visible': true,
          'dates': dat,
        });
    }catch(e){
      print(e);
      return null;
    }
  }

  Future createProposition(UserData choosedUserData,String libelle,int price,Map<String,DateTime> dat) async {

    UserData userData = await UserDao(uid).getUserData();


    Map<String,String> senderInfo= new Map();
    senderInfo['senderName']= userData.name;
    senderInfo['senderSurname']= userData.surname;
    senderInfo['senderEmail']= userData.email;

    Map<String,String> receiverInfo= new Map();
    receiverInfo['receiverName']= choosedUserData.name;
    receiverInfo['receiverSurname']= choosedUserData.surname;
    receiverInfo['receiverEmail']= choosedUserData.email;

    try {
      print("create PROPOSITION");
      return propositionCollection.document().setData({
        'senderId': userData.uid,
        'receiverId': choosedUserData.uid,
        'libelle': libelle,
        'price': price,
        'sendDate': DateTime.now(),
        'status': 'EN ATTENTE',
        'visible': true,
        'dates': dat,
        'senderInfo': senderInfo,
        'receiverInfo': receiverInfo,
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de propositions
  Stream<List<Proposition>> get getPropositions{
    return propositionCollection.where("visible",isEqualTo: true).where("status",isEqualTo: "EN ATTENTE").snapshots().map(_propositionListFromSnapshots);

  }

  //fonction utile pour le cast
  List<Proposition> _propositionListFromSnapshots(QuerySnapshot snapshot){
    Map<String,String> receiverInfo=  new Map();
    Map<String,String> senderInfo=  new Map();
    Map<String,DateTime> dat=  new Map();
    dat['startDate']= DateTime(0000,00,00);
    dat['endDate']= DateTime(0000,00,00);
    return snapshot.documents.map((doc){
      receiverInfo['receiverName']= doc.data['receiverInfo']['receiverName'];
      receiverInfo['receiverSurname']= doc.data['receiverInfo']['receiverSurname'];
      receiverInfo['receiverEmail']= doc.data['receiverInfo']['receiverEmail'];
      senderInfo['senderName']= doc.data['senderInfo']['senderName'];
      senderInfo['senderSurname']= doc.data['senderInfo']['senderSurname'];
      senderInfo['senderEmail']= doc.data['senderInfo']['senderEmail'];
      return Proposition(
        documentId: doc.documentID,
        senderId: doc.data['senderId'],
        receiverId: doc.data['receiverId'],
        libelle: doc.data['libelle'],
          sendDate:  DateTime(0000,00,00),
        price: doc.data['price'],
        status: doc.data['status'],
        visible: doc.data['visible'],
        dat: dat,
        senderInfo: senderInfo,
        receiverInfo: receiverInfo
      );
    }).toList();
  }

  Future deleteProposition(Proposition proposition){
    try{
      return propositionCollection.document(proposition.documentId).delete();
    }catch(e){
      print(e);
      return null;
    }
  }

  Future refuseProposition(Proposition proposition){
    try{
      return propositionCollection.document(proposition.documentId).updateData(({
        'status': "REFUSE",
        'visible':false
      }));
    }catch(e){
      print(e);
      return null;
    }
  }

  Future acceptProposition(Proposition proposition) async {   // not  implemented yet
    try{
       propositionCollection.document(proposition.documentId).updateData(({
        'visible':false
      }));
      return await ContractDao(uid: uid).createContract(proposition);
    }catch(e){
      print(e);
      return null;
    }
  }

}