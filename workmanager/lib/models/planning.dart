
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
  
  String planningId;
  String documentId;
  DateTime startDate;  // jour et heure de début fixée
  DateTime endDate;  // jour et heure de fin fixée
  String QR;        // QR code associé à la journée
  
    Day(this.documentId,this.planningId,this.startDate,this.endDate,this.QR);
}
class Seance{
  
  String dayId;
  String documentId;
  DateTime startDate;  // date de début réelle d'une session de travail journalière
  DateTime endDate;     // date de fin du réelle d'une session de travail journalière
  String QR;        // QR code effectivement scanné cette journée 
Seance(this.documentId,this.dayId,this.startDate,this.endDate,this.QR);
}