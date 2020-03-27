import 'package:cloud_firestore/cloud_firestore.dart';

class PropositionDao{

  final CollectionReference propositionCollection= Firestore.instance.collection("propositions");

}