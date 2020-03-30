
import 'package:flutter/material.dart';

class Planning{
  String contratId;
  DateTime startDate;  // date de début du contrat
  DateTime endDate;     // date de fin du contrat
  TimeOfDay startHour;  // heure de début fixée
  TimeOfDay endHour;  // heure de fin fixée
  bool canceled;     // contrat annulé ou pas

}

class Seance{
  String planningId;
  DateTime startDate;  // date de début réelle d'une session de travail journalière
  DateTime endDate;     // date de fin du réelle d'une session de travail journalière
}