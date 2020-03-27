import 'package:cloud_firestore/cloud_firestore.dart';

class ContractDao{

  final CollectionReference contractCollection= Firestore.instance.collection("propositions");
}