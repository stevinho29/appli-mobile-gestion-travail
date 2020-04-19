import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/proposition.dart';
import 'package:work_manager/services/calculator.dart';

class ContractDao{

  String uid;
  ContractDao({this.uid});

  final CollectionReference contractCollection= Firestore.instance.collection("contracts");

  Future updateContractData(Contract contractData,String libelle,double price,Map<String,DateTime> dat) async {
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

  Future updateContractCursor(Contract contractData,int cursor) async {
    try{
      return contractCollection.document(contractData.documentId).updateData({
        'cursorPayment': cursor,
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
    Map<String,String> employeeInfo= new Map();
    if(proposition.origin== "employer") {
      employerInfo['employerName'] = proposition.senderInfo['senderName'];
      employerInfo['employerSurname'] = proposition.senderInfo['senderSurname'];
      employerInfo['employerEmail'] = proposition.senderInfo['senderEmail'];
      employerInfo['employerAddress'] = proposition.senderInfo['senderAddress'];
      employerInfo['employerCodePostal'] =
      proposition.senderInfo['senderCodePostal'];

      employeeInfo['employeeName'] = proposition.receiverInfo['receiverName'];
      employeeInfo['employeeSurname'] =
      proposition.receiverInfo['receiverSurname'];
      employeeInfo['employeeEmail'] = proposition.receiverInfo['receiverEmail'];
      employeeInfo['employeeAddress'] =
      proposition.receiverInfo['receiverAddress'];
      employeeInfo['employeeCodePostal'] =
      proposition.receiverInfo['receiverCodePostal'];
    }else{
      employerInfo['employerName'] = proposition.receiverInfo['receiverName'];
      employerInfo['employerSurname'] = proposition.receiverInfo['receiverSurname'];
      employerInfo['employerEmail'] = proposition.receiverInfo['receiverEmail'];
      employerInfo['employerAddress'] = proposition.receiverInfo['receiverAddress'];
      employerInfo['employerCodePostal'] = proposition.receiverInfo['receiverCodePostal'];

      employeeInfo['employeeName'] = proposition.senderInfo['senderName'];
      employeeInfo['employeeSurname'] =proposition.senderInfo['senderSurname'];
      employeeInfo['employeeEmail'] = proposition.senderInfo['senderEmail'];
      employeeInfo['employeeAddress'] =proposition.senderInfo['senderAddress'];
      employeeInfo['employeeCodePostal'] =proposition.senderInfo['senderCodePostal'];
    }

    Map<String,DateTime> dat= new Map();
    dat['startDate']= DateTime.now();
    dat['endDate']= DateTime.now();
    print("here");
    try {
      return contractCollection.document().setData({
        'employerId': proposition.senderId,
        'employeeId': proposition.receiverId,
        'libelle': proposition.libelle,
        'description': proposition.description,
        'hourPerWeek': proposition.hourPerWeek,
        'pricePerHour': proposition.price,
        'cursorPayment': 0,
        'canceled': false,
        'dates': proposition.dat,
        'employerInfo': employerInfo,
        'employeeInfo': employeeInfo,
        'planningVariable':proposition.planningVariable,
        'validation': ['geolocation']
      });

    } catch(e) {
      print(e);
      print("failure when attempting to create a contract");
      return null;
    }
  }

  Future updateContractException(Exceptions exceptions,double price,Map<String,DateTime> dat,String motif) async{
    try{
        return await contractCollection.document(exceptions.contratId).collection('exceptions').document(exceptions.documentId)
            .updateData({
          'motif':motif,
          'price':price,
          'startDate': dat['startDate'],
          'endDate': dat['endDate']
        });
    }catch(e){
      print(e);
      print("failure when attempting to uopdate an exception of a contract");
    }
  }
  Future createContractException(Contract contract, Map<String,DateTime> dat,String motif,double price) async{
    try{
      String origin;
      if(contract.employerId== uid) origin= "employer";
      else origin= "employee";
       return await contractCollection.document(contract.documentId).collection("exceptions").document().setData({
          'contratId':contract.documentId,
          'origin': origin,
          'motif':motif,
          'price': price,
          'startDate':dat['startDate'],
          'endDate':dat['endDate']
        });
    }catch(e){
      print(e);
      print("failure when attempting to create exception in a contract");
      return null;
    }
  }
  Future deleteContractException(Exceptions exceptionData) async {
    try{
      return await contractCollection.document(exceptionData.contratId).collection("exceptions").document(exceptionData.documentId).delete();
    }catch(e){
      print(e);
      print("failure when attempting to delete exception in a contract");
    }
  }
Future<List<Exceptions>> getExceptionList(Contract contract) async {
    try{
      return await contractCollection.document(contract.documentId).collection('exceptions').getDocuments().then((qShot){
        return qShot.documents.map((doc){
          return Exceptions(
              documentId: doc.documentID,
              contratId: doc.data['contratId'],
              motif: doc.data['motif'],
              price: doc.data['price']?.toDouble() ?? 0.0,
              startDate: DateTime.fromMillisecondsSinceEpoch(doc.data['startDate'].millisecondsSinceEpoch),
              endDate: DateTime.fromMillisecondsSinceEpoch(doc.data['endDate'].millisecondsSinceEpoch)
          );
        }).toList();
      });
    }catch(e){
      print(e);
      print("failure when attempting to get exceptions list");
      return null;
    }
}

  Stream<List<Exceptions>>  getContractExceptions(Contract contract){
    //print("EXCEPTIONS CONTRACT ${contract.documentId}");
    try {
      Stream<List<Exceptions>> list = contractCollection.document(
          contract.documentId).collection('exceptions').snapshots().map(
          _fromSnapToExceptions);
      list.listen((event) {
        print(event[0].motif);
        return list;
      });
    }catch(e){
      print(e);
      print("failure on getContracts Exceptions stream");
    }


  }

  List<Exceptions> _fromSnapToExceptions(QuerySnapshot snapshot){
   return snapshot.documents.map((doc) {
     //print(doc.documentID);
     return Exceptions(
        documentId: doc.documentID,
        contratId: doc.data['contratId'],
        motif: doc.data['motif'],
        price: doc.data['price']?.toDouble() ?? 0.0,
        startDate: DateTime.fromMillisecondsSinceEpoch(doc.data['startDate'].millisecondsSinceEpoch),
        endDate: DateTime.fromMillisecondsSinceEpoch(doc.data['endDate'].millisecondsSinceEpoch)
      );
    }).toList();
  }

  // liste de contrats
  Stream<List<Contract>> get getContracts{

    Stream<List<Contract>> list=  contractCollection.where("employerId",isEqualTo: uid ).where("canceled",isEqualTo: false).snapshots().map(_contractListFromSnapshots);
    list.listen((event) {
      try {
        print("ICI ${event[0].libelle}");
      }catch(e){
        print(e);
        print("failure on getContracts stream");
        }
    });
    return list;
  }
  Stream<List<Contract>> get getEmployeeContracts{

    Stream<List<Contract>> list= contractCollection.where("employeeId",isEqualTo: uid ).where("canceled",isEqualTo: false).snapshots().map(_contractListFromSnapshots);
    list.listen((event) {
      try {
        print(event[0].libelle);
      }catch(e){
        print(e);
        print('failure on getEmploye Stream');
      }
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
      employeeInfo['employeeAddress']= doc.data['employeeInfo']['employeeAddress'] ?? "41 Boulevard Vauban";
      employeeInfo['employeeCodePostal']= doc.data['employeeInfo']['employeeCodePostal'] ?? "59000";

      employerInfo['employerName']= doc.data['employerInfo']['employerName'];
      employerInfo['employerSurname']= doc.data['employerInfo']['employerSurname'];
      employerInfo['employerEmail']= doc.data['employerInfo']['employerEmail'];
      employerInfo['employerAddress']= doc.data['employerInfo']['employerAddress'] ?? "41 Boulevard Vauban";
      employerInfo['employerCodePostal']= doc.data['employerInfo']['employerCodePostal'] ?? "59000";
      //print("JE REGARDE LADDRESS${doc.data['employerInfo']['employerAddress']}");
      return Contract(doc.documentID,doc.data['employerId'],doc.data['employeeId'],doc.data['libelle'],doc.data['description'] ?? "",
         doc.data['hourPerWeek'].toDouble() ?? 30.0, doc.data['pricePerHour'].toDouble() ?? 0.0,doc.data['cursorPayment'] ?? 0, DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch),DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch),doc.data['canceled'],
      employerInfo,employeeInfo,doc.data['planningVariable'] ??false, ['geolocation']);
    }).toList();
  }

  Future deleteContract(Contract contract){
    try{
      return contractCollection.document(contract.documentId).delete();
    }catch(e){
      print(e);
      print("failure when deleting contract");
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
        'canceled':true
      }));
    }catch(e){
      print(e);
      print("failure when cancelling contract");
      return null;
    }
  }



  ////          PaymentDao

  Future createPayment(Contract contract,Calculator calculator) async{
    try{
      print('CREATING PAYMENT');
      print(calculator.startDate);
      return await contractCollection.document(contract.documentId).collection("payments").document().setData({
        'contratId':contract.documentId,
        'startDate': calculator.startDate,
        'endDate': calculator.endDate,
        'cursorPayment': contract.cursorPayment+1,
        'workedHour': calculator.normalHours,
        'exceptionsHour':calculator.exceptionsHour,
        'basicSalary': calculator.normalHourPrice,
        //'additionalHour':calculator.ov,
        'overtime':calculator.overtime,
        'pricePerHour': contract.pricePerHour,
        'finalSalary':calculator.totalHourPrice
      });
    }catch(e){
      print(e);
      print("failure when attempting to create a payment in a contract");
      return null;
    }
  }
  Future deletePayment(Payment paymentData) async {
    try{
      return await contractCollection.document(paymentData.contratId).collection("payments").document(paymentData.documentId).delete();
    }catch(e){
      print(e);
      print("failure when attempting to delete exception in a contract");
    }
  }

  Stream<List<Payment>>  getPayments(Contract contract){
    //print("PAYMENTS CONTRACT ${contract.documentId}");
    Stream<List<Payment>> list= contractCollection.document(contract.documentId).collection('payments').snapshots().map(_fromSnapToPayments);
    list.listen((event) {
      try {
        print(event[0].finalSalary);
      }catch(e){
        print(e);
        print("empty payment list");
      }
    });

    return list;
  }

  List<Payment> _fromSnapToPayments(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      //print(doc.documentID);
      return Payment(
          documentId: doc.documentID,
          contratId: doc.data['contratId'],
          startDate: DateTime.fromMillisecondsSinceEpoch(doc.data['startDate'].millisecondsSinceEpoch),
          endDate: DateTime.fromMillisecondsSinceEpoch(doc.data['endDate'].millisecondsSinceEpoch),
          cursorPayment: doc.data['cursorPayment'],
          workedHour: doc.data['workedHour'].toDouble(),
          exceptionsHour: doc.data['exceptionsHour'].toDouble(),
          basicSalary: doc.data['basicSalary'].toDouble(),
          //additionalHour: doc.data['additionalHour'],
          overtime: doc.data['overtime'].toDouble(),
          pricePerHour: doc.data['pricePerHour'].toDouble() ?? 7.93,
          finalSalary: doc.data['finalSalary'].toDouble()
      );
    }).toList();
  }


}