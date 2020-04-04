import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';

class PlanningDao{

  final CollectionReference planningCollection= Firestore.instance.collection("planning");

  Future updatePlanningData(Contract contract,Map<String,DateTime> dat) async {
    try{
      return planningCollection.document(contract.documentId).updateData({
        'dates': dat,
      });
    }catch(e){
      print(e);
      return null;
    }
  }

  Future createPlanning(Contract contract,Map<String,DateTime> dat, Map<int,DateTime> choosedat,Map<int,bool> chooseDays) async {

    List<int> keys = List();
    chooseDays.forEach((key, value) {   // je récupère toutes les jours qui ont été sélectionnés
      if(value)
        keys.add(key);
    });
    print(("JOURS SELECTED ${keys[0]}"));
    String documentId= DateTime.now().toString();
    try {
      print("create PLANNING");
       await planningCollection.document(documentId).setData({
        'contratId':contract.documentId,
        'dates': dat,
      }).then((value) {
         for (int i=0 ; i < keys.length;i++) { // on récupère les dates de tous les jours qui ont été sélectionnés
           print(("KEYS ${keys[i]}"));
           dat['startDate']= choosedat[keys[i]];
           dat['endDate']= choosedat[keys[i]];
           createDayOfPlanning(documentId, dat, "no QR");
         }
       });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de planning
  Stream<List<Planning>>  getPlanning (Contract contract){
    return planningCollection.where("contratId",isEqualTo: contract.documentId).orderBy("dates.endDate",descending: true).snapshots().map(_planningListFromSnapshots);

  }

  //fonction utile pour le cast
  List<Planning> _planningListFromSnapshots(QuerySnapshot snapshot){

    Map<String,DateTime> dat=  new Map();
    return snapshot.documents.map((doc){

      dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
      dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
      return Planning(doc.documentID,doc.data['contratId'],dat['startDate'],dat['endDate']);
    }).toList();
  }
  
  Future<bool> checkIfPlanningAlreadyExist() async {
    Map<String,DateTime> dat=  new Map();
    bool result;
    await planningCollection.where("dates.endDate",isLessThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+3) ).getDocuments().then((qShot) async {
       List<Planning> list= qShot.documents.map((doc) {
        dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
        dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
         Planning(doc.documentID,doc.data['contratId'],dat['startDate'],dat['endDate']);
        }).toList();
       await planningCollection.getDocuments().then((qShot){
        List<Planning> list2= qShot.documents.map((doc){
          dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
          dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
          Planning(doc.documentID,doc.data['contratId'],dat['startDate'],dat['endDate']);
         }).toList();
        print("LIST2 ${list2.length}");
        if( list2.length > 0){ // si au moins un planning existe
          if(list.length > 0){  // si je suis rentré dans la période de création
             result= false;
          }
          else {
            result = true;
            print("mauvaise période");
          }
        }
        else{ // je n'ai jamais crée de planning
          result = false;
          print("pas de planning at all");
        }
       });
      });
    return result;
  }

  Future deletePlanning(Planning planning){
    try{
      return planningCollection.document(planning.documentId).delete();
    }catch(e){
      print(e);
      return null;
    }
  }




  // DAO POUR LES JOURS D UN PLANNING DEFINI




  Future updateDayOfPlanningData(Day day,Map<String,DateTime> dat) async {
    try{
      return planningCollection.document(day.planningId).collection("days").document(day.documentId).updateData({
        'dates': dat,
        'startValidated':day.startValidated,
        'endValidated': day.endValidated
      });
    }catch(e){
      print(e);
      return null;
    }
  }

  Future createDayOfPlanning(String documentId,Map<String,DateTime> dat,String QR) async {

    try {
      print("creating DAY of PLANNING");
      return planningCollection.document(documentId).collection("days").document().setData({
        'planningId':documentId,
        'dates': dat,
        'startValited':false,
        'endValidated':false,
        'QR': QR ?? "no QR"
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de jours contenus dans un planning

  Stream<List<Day>>  getDaysOfPlanning (Planning planning){
    return planningCollection.document(planning.documentId).collection("days").orderBy("dates.startDate").snapshots().map(_dayOfPlanningListFromSnapshots);

  }

  //fonction utile pour le cast
  List<Day> _dayOfPlanningListFromSnapshots(QuerySnapshot snapshot){

    Map<String,DateTime> dat=  new Map();
    return snapshot.documents.map((doc){

      dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
      dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
      return Day(doc.documentID,doc.data['planningId'],dat['startDate'],dat['endDate'],doc.data['startValidated']??false,doc.data['endValidated']??false,doc.data['QR']);
    }).toList();
  }

  Future deleteDayOfPlanning(Day day){
    try{
      return planningCollection.document(day.planningId).collection("days").document(day.documentId).delete();
    }catch(e){
      print(e);
      return null;
    }
  }

Future<bool> checkIfPeriodOfDayAlreadyExist(Map<String,DateTime> dat,Planning planning) async {
  Map<String,DateTime> dats=  new Map();
  bool result;
  print("ENDDATE${dat["endDate"]}");
    await planningCollection.document(planning.documentId).collection('days').where("dates.endDate",isGreaterThan: dat['startDate']).where("dates.endDate",isLessThan:dat['endDate']).getDocuments().then((docs){
     List<Day> list=  docs.documents.map((doc){
       dats['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
       dats['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
         Day(doc.documentID,doc.data['planningId'],dat['startDate'],dat['endDate'],doc.data['startValidated'],doc.data['endValidated'],doc.data['QR']);
      }).toList();
     if(list.length > 0)
       result= true;
     else
       result= false;
    });
     print(result);
     return result;
}

// DAO POUR LES SEANCES EFFECTIVES  D UN PLANNING DEFINI


  Future createSeanceOfDay(Day day,Map<String,DateTime> dat,String QR) async {  // col Planning => Doc => col Days => Doc => col Seances
    try {
      print("creating SEANCE OF DAY of PLANNING");
      await updateDayOfPlanningData(day, {'startDate':day.startDate, 'endDate':day.endDate}); // on met à jour le day avec le début de séance et/ou la fin validée
      return planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seance").document().setData({
        'dayId':day.documentId,
        'dates': dat,
        'QR': QR ?? "no QR"
      });
    } catch(e) {
      print(e);
      return null;
    }
  }
  Future updateSeanceOfDay(Seance seance,Day day,dat,String QR) async {
    try{
      await updateDayOfPlanningData(day, {'startDate':day.startDate, 'endDate':day.endDate}); // on met à jour le day avec le début de séance et/ou la fin validée
      return planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seance").document(seance.documentId).setData({
        'dayId':day.documentId,
        'dates': dat,
        'QR': QR ?? "no QR"
      });
    }catch(e){
      print(e);
      return null;
    }
  }

  // liste de jours contenus dans un planning

  Stream<List<Seance>>  getSeanceOfDay (Day day){
    return planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seance").snapshots().map(_seanceOfDayListFromSnapshots);

  }

  Future<List<Seance>> getSeance(Day day) async {
    Map<String,DateTime> dat=  new Map();
   return await planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seance").getDocuments().then((qShot) {
     return qShot.documents.map((doc){
       print(" SEANCE ${doc.data['dates']}");
        dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
        dat['endDate']= DateTime.now();
      return  Seance(doc.documentID,doc.data['dayId'],dat['startDate'],dat['endDate'],doc.data['QR']);
      }).toList();
    });
  }

  //fonction utile pour le cast
  List<Seance> _seanceOfDayListFromSnapshots(QuerySnapshot snapshot){

    Map<String,DateTime> dat=  new Map();
    return snapshot.documents.map((doc){

      dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
      dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
      return Seance(doc.documentID,doc.data['dayId'],dat['startDate'],dat['endDate'],doc.data['QR']);
    }).toList();
  }


}