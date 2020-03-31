import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';

class PlanningDao{

  final CollectionReference planningCollection= Firestore.instance.collection("propositions");

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

  Future createPlanning(Contract contract,Map<String,DateTime> dat) async {

    try {
      print("create PLANNING");
      return planningCollection.document().setData({
        'contratId':contract.documentId,
        'dates': dat,
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de planning
  Stream<List<Planning>>  getPlanning (Contract contract){
    return planningCollection.where("contratId",isEqualTo: contract.documentId).snapshots().map(_planningListFromSnapshots);

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
      });
    }catch(e){
      print(e);
      return null;
    }
  }

  Future createDayOfPlanning(Planning planning,Map<String,DateTime> dat,String QR) async {

    try {
      print("creating DAY of PLANNING");
      return planningCollection.document(planning.documentId).collection("days").document().setData({
        'planningId':planning.documentId,
        'dates': dat,
        'QR': QR ?? "no QR"
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de jours contenus dans un planning

  Stream<List<Day>>  getDaysOfPlanning (Planning planning){
    return planningCollection.document(planning.documentId).collection("days").snapshots().map(_dayOfPlanningListFromSnapshots);

  }

  //fonction utile pour le cast
  List<Day> _dayOfPlanningListFromSnapshots(QuerySnapshot snapshot){

    Map<String,DateTime> dat=  new Map();
    return snapshot.documents.map((doc){

      dat['startDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['startDate'].millisecondsSinceEpoch);
      dat['endDate']= DateTime.fromMillisecondsSinceEpoch(doc.data['dates']['endDate'].millisecondsSinceEpoch);
      return Day(doc.documentID,doc.data['planningId'],dat['startDate'],dat['endDate'],doc.data['QR']);
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



// DAO POUR LES SEANCES EFFECTIVES  D UN PLANNING DEFINI


  Future createSeanceOfDay(Day day,Map<String,DateTime> dat,String QR) async {  // col Planning => Doc => col Days => Doc => col Seances
    try {
      print("creating SEANCE OF DAY of PLANNING");
      return planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seances").document().setData({
        'dayId':day.documentId,
        'dates': dat,
        'QR': QR ?? "no QR"
      });
    } catch(e) {
      print(e);
      return null;
    }
  }

  // liste de jours contenus dans un planning

  Stream<List<Seance>>  getSeancesOfDays (Day day){
    return planningCollection.document(day.planningId).collection("days").document(day.documentId).collection("seances").snapshots().map(_seanceOfDayListFromSnapshots);

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