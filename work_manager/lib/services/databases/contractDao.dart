import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workmanager/models/contract.dart';
import 'package:workmanager/models/proposition.dart';

class ContractDao{

  String uid;
  ContractDao({this.uid});

  final CollectionReference contractCollection= Firestore.instance.collection("contracts");

  Future updateContractData(Contract contractData,String libelle,int price,Map<String,DateTime> dat) async {
    try{
      return contractCollection.document(contractData.documentId).updateData({
        'libelle': libelle,
        'price':price,
        'validate': true,
        'dates': dat,
      });
    }catch(e){
      print(e);
      return null;
    }
  }

  Future createContract(Proposition proposition) async {

    print("create CONTRACT");
    print(("PROPOSITIONS $proposition}"));
    print("object dat ${proposition.dat}" );

    Map<String,String> employerInfo= new Map();
    employerInfo['employerName']= proposition.senderInfo['senderName'];
    employerInfo['employerSurname']= proposition.senderInfo['senderSurname'];
    employerInfo['employerEmail']= proposition.senderInfo['senderEmail'];

    Map<String,String> employeeInfo= new Map();
    employeeInfo['employeeName']= proposition.receiverInfo['receiverName'];
    employeeInfo['employeeSurname']= proposition.receiverInfo['receiverSurname'];
    employeeInfo['employeeEmail']= proposition.receiverInfo['receiverEmail'];

    Map<String,DateTime> dat= new Map();
    dat['startDate']= DateTime.now();
    dat['endDate']= DateTime.now();
    print("here");
    try {
      return contractCollection.document().setData({
        'employerId': proposition.senderId,
        'employeeId': proposition.receiverId,
        'libelle': proposition.libelle,
        'pricePerHour': proposition.price,
        'validate': false,
        'dates': dat,
        'employerInfo': employerInfo,
        'employeeInfo': employeeInfo,
      });

    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de propositions
  Stream<List<Contract>> get getContracts{

    Stream<List<Contract>> list= contractCollection.where("employerId",isEqualTo: uid ).snapshots().map(_contractListFromSnapshots);
    list.listen((event) {
      print(event[0].libelle);
    });
    return list;
  }

  //fonction utile pour le cast
  List<Contract> _contractListFromSnapshots(QuerySnapshot snapshot){
    Map<String,String> employerInfo=  new Map();
    Map<String,String> employeeInfo=  new Map();
    Map<String,DateTime> dat=  new Map();
    dat['startDate']= DateTime(0000,00,00);
    dat['endDate']= DateTime(0000,00,00);
    return snapshot.documents.map((doc){
      print("je print DOC $doc");
      employeeInfo['employeeName']= doc.data['employeeInfo']['employeeName'];
      employeeInfo['employeeSurname']= doc.data['employeeInfo']['employeeSurname'];
      employeeInfo['employeeEmail']= doc.data['employeeInfo']['employeeEmail'];

      employerInfo['employerName']= doc.data['employerInfo']['employerName'];
      employerInfo['employerSurname']= doc.data['employerInfo']['employerSurname'];
      employerInfo['employerEmail']= doc.data['employerInfo']['employerEmail'];

      return Contract(doc.documentID,doc.data['employerId'],doc.data['employeeId'],doc.data['libelle'],
          doc.data['pricePerHour'],dat['startDate'],dat['endDate'],doc.data['validate'],
      employerInfo,employeeInfo);
    }).toList();
  }

  Future deleteContract(Contract contract){
    try{
      return contractCollection.document(contract.documentId).delete();
    }catch(e){
      print(e);
      return null;
    }
  }

  Future cancelContract(Contract contract){
    try{
      return contractCollection.document(contract.documentId).updateData(({
        'validate':false
      }));
    }catch(e){
      print(e);
      return null;
    }
  }

  Future acceptProposition(Contract contract){   // not  implemented yet
    try{
      return contractCollection.document(contract.documentId).updateData(({
        'visible':false
      }));
    }catch(e){
      print(e);
      return null;
    }
  }
}