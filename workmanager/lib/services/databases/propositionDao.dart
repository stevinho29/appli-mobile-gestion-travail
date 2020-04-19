import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/proposition.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/services/databases/userDao.dart';

class PropositionDao{

  String uid;
  PropositionDao({this.uid});

  final CollectionReference propositionCollection= Firestore.instance.collection("propositions");


  Future updatePropositionData(Proposition propositionData,String libelle,double price,Map<String,DateTime> dat) async {
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

  Future createProposition(UserData choosedUserData,String libelle,double price,Map<String,DateTime> dat,bool planningVariable,String origin,String description,double hourPerWeek) async {

    UserData userData = await UserDao(uid).getUserData();
    Map<String, String> senderInfo = new Map();
    Map<String, String> receiverInfo = new Map();

  senderInfo['senderName'] = userData.name;
  senderInfo['senderSurname'] = userData.surname;
  senderInfo['senderEmail'] = userData.email;
  senderInfo['senderAddress'] = userData.address;
  senderInfo['senderCodePostal'] = userData.codePostal;

  receiverInfo['receiverName'] = choosedUserData.name;
  receiverInfo['receiverSurname'] = choosedUserData.surname;
  receiverInfo['receiverEmail'] = choosedUserData.email;
  receiverInfo['receiverAddress'] = choosedUserData.address;
  receiverInfo['receiverCodePostal'] = choosedUserData.codePostal;


    try {
      print("create PROPOSITION");
      return propositionCollection.document().setData({
        'senderId': userData.uid,
        'receiverId': choosedUserData.uid,
        'libelle': libelle,
        'origin': origin,
        'description': description,
        'hourPerWeek': hourPerWeek,
        'price': price,
        'sendDate': DateTime.now(),
        'status': 'EN ATTENTE',
        'visible': true,
        'dates': dat,
        'senderInfo': senderInfo,
        'receiverInfo': receiverInfo,
        'planningVariable': planningVariable
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
    return snapshot.documents.where((element) {
      if(element.data['receiverId'] == uid || element.data['senderId'] == uid)
        return true;
      else
        return false;
    }).map((doc){
      receiverInfo['receiverName']= doc.data['receiverInfo']['receiverName'];
      receiverInfo['receiverSurname']= doc.data['receiverInfo']['receiverSurname'];
      receiverInfo['receiverEmail']= doc.data['receiverInfo']['receiverEmail'];
      receiverInfo['receiverAddress']= doc.data['receiverInfo']['receiverAddress'];
      receiverInfo['receiverCodePostal']= doc.data['receiverInfo']['receiverCodePostal'];

      senderInfo['senderName']= doc.data['senderInfo']['senderName'];
      senderInfo['senderSurname']= doc.data['senderInfo']['senderSurname'];
      senderInfo['senderEmail']= doc.data['senderInfo']['senderEmail'];
      senderInfo['senderAddress']= doc.data['senderInfo']['senderAddress'];
      senderInfo['senderCodePostal']= doc.data['senderInfo']['senderCodePostal'];

      dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
      dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
      print("DATES PROPOSITIONS ${dat['endDate']}");
      return Proposition(
        documentId: doc.documentID,
        senderId: doc.data['senderId'],
        receiverId: doc.data['receiverId'],
        libelle: doc.data['libelle'],
          origin: doc.data['origin'] ?? "employer" ,
          description: doc.data["description"] ?? "",
          hourPerWeek: doc.data['hourPerWeek']?.toDouble() ?? 10.0,
          price: doc.data['price']?.toDouble(),
          sendDate:  DateTime.fromMillisecondsSinceEpoch(doc.data['sendDate'].millisecondsSinceEpoch),
        status: doc.data['status'],
        visible: doc.data['visible'],
        dat: dat,
        senderInfo: senderInfo,
        receiverInfo: receiverInfo,
        planningVariable: doc.data['planningVariable'] ?? false
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