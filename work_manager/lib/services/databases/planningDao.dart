import 'package:cloud_firestore/cloud_firestore.dart';

class PlanningDao{

  final CollectionReference planningCollection= Firestore.instance.collection("propositions");
}