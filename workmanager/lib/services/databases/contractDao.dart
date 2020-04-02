import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/proposition.dart';

class ContractDao{

  String uid;
  ContractDao({this.uid});

  final CollectionReference contractCollection= Firestore.instance.collection("contracts");

  Future updateContractData(Contract contractData,String libelle,int price,Map<String,DateTime> dat) async {
    try{
      return contractCollection.document(contractData.documentId).updateData({
        'libelle': libelle,
        'price':price,
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
        'planningVariable':proposition.planningVariable,
        'validation': ['geolocation']
      });

    } catch(e) {
      print(e);
      return null;
    }
  }

  Future createContractException(Contract contract, Map<String,DateTime> dat,String motif,int price){
    try{
       return contractCollection.document(contract.documentId).collection("exceptions").document().setData({
          'contratId':contract.documentId,
          'motif':motif,
          'price': price,
          'startDate':dat['startDate'],
          'endDate':dat['endDate']
        });
    }catch(e){
      print(e);
      return null;
    }
  }

  Stream<List<Exceptions>>  getContractExceptions(Contract contract){
    print("EXCEPTIONS CONTRACT ${contract.documentId}");
    Stream<List<Exceptions>> list= contractCollection.document(contract.documentId).collection('exceptions').snapshots().map(_fromSnapToExceptions);
    list.listen((event) {
      print(event[0].motif);
    });

    return list;
  }

  List<Exceptions> _fromSnapToExceptions(QuerySnapshot snapshot){
   return snapshot.documents.map((doc) {
     print(doc.documentID);
     return Exceptions(
        documentId: doc.documentID,
        contratId: doc.data['contratId'],
        motif: doc.data['motif'],
        price: doc.data['price'],
        startDate: DateTime.fromMillisecondsSinceEpoch(doc.data['startDate'].millisecondsSinceEpoch),
        endDate: DateTime.fromMillisecondsSinceEpoch(doc.data['endDate'].millisecondsSinceEpoch)
      );
    }).toList();
  }

  // liste de contrats
  Stream<List<Contract>> get getContracts{

    Stream<List<Contract>> list= contractCollection.where("employerId",isEqualTo: uid ).snapshots().map(_contractListFromSnapshots);
    list.listen((event) {
      print(event[0].libelle);
    });
    return list;
  }
  Stream<List<Contract>> get getEmployeeContracts{

    Stream<List<Contract>> list= contractCollection.where("employeeId",isEqualTo: uid ).snapshots().map(_contractListFromSnapshots);
    list.listen((event) {
      print(event[0].libelle);
    });
    return list;
  }

  //fonction utile pour le cast
  List<Contract> _contractListFromSnapshots(QuerySnapshot snapshot){
    Map<String,String> employerInfo=  new Map();
    Map<String,String> employeeInfo=  new Map();

    return snapshot.documents.map((doc){
      print("je print DOC $doc");
      employeeInfo['employeeName']= doc.data['employeeInfo']['employeeName'];
      employeeInfo['employeeSurname']= doc.data['employeeInfo']['employeeSurname'];
      employeeInfo['employeeEmail']= doc.data['employeeInfo']['employeeEmail'];

      employerInfo['employerName']= doc.data['employerInfo']['employerName'];
      employerInfo['employerSurname']= doc.data['employerInfo']['employerSurname'];
      employerInfo['employerEmail']= doc.data['employerInfo']['employerEmail'];

      return Contract(doc.documentID,doc.data['employerId'],doc.data['employeeId'],doc.data['libelle'],
          doc.data['pricePerHour'],DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch),DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch),doc.data['validate'],
      employerInfo,employeeInfo,doc.data['planningVariable'] ??false, ['geolocation']);
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
      print("CANCEL CONTRACT ${contract.startDate}");
      Map<String,DateTime> dat= new Map();
      dat['startDate']= contract.startDate;
      dat['endDate']= DateTime.now();

      return contractCollection.document(contract.documentId).updateData(({
        'dates':dat,
        'validate':false
      }));
    }catch(e){
      print(e);
      return null;
    }
  }

}