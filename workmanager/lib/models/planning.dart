
class Planning{ // un planning est fait périodiquement pour des contrats variables (min 7 jours max 14 jours)
  // il commence toujours un lundi et se termine toujours un dimanche
  
  String contratId;
  String documentId;
  DateTime startDate;  // date de début du planning
  DateTime endDate;     // date de fin du contrat
  
  bool canceled;     // contrat annulé ou pas (pas utilisé pour le moment )
  
Planning(this.documentId,this.contratId,this.startDate,this.endDate);
}

class Day{
  
  String contractId;
  String documentId;
  DateTime startHour;  // jour et heure de début fixée
  DateTime endHour;  // jour et heure de fin fixée
  bool startValidated; // si le début de séance a été validé ( la séance a été crée)
  bool endValidated; // si la fin de séance a été validée ( la séance a été crée)
  String QR;        // QR code associé à la journée
  
    Day(this.documentId,this.contractId,this.startHour,this.endHour,this.startValidated,this.endValidated,this.QR);
}
class Seance{
  
  String dayId;
  String documentId;
  DateTime startHour;  // date de début réelle d'une session de travail journalière
  DateTime endHour;     // date de fin du réelle d'une session de travail journalière
  String QR;        // QR code effectivement scanné cette journée 
Seance(this.documentId,this.dayId,this.startHour,this.endHour,this.QR);
}