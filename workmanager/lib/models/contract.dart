class Contract{  // contient des données dénormalisées sur l'employeur et l'employé (representés par une Map employerInfo et une Map employeeInfo dans firestore)

  Map<String,String> employerInfo;
  String employerName;   // nom de l'employeur
  String employerSurname; // prenom de l'employeur
  String employerEmail;   // email de l'amployeur
  String employerAddress;         // adresse de l'employeur
  String employerCodePostal;    // code postal de l'employeur

  Map<String,String> employeeInfo;
  String employeeName;   // nom de l'employé
  String employeeSurname; // prenom de l'employé
  String employeeEmail;   //  email de l'amployé
  String employeeAddress;         // adresse de l'employé
  String employeeCodePostal;    // code postal de l'employé

  String documentId;
  String employerId;
  String employeeId;
  String libelle;
  String description;   //descriptif des taches ou des compétences
  int pricePerHour;
  int cursorPayment;    // compteur qui indique combien de factures(fiche de paie) ont deja été délivrées pour ce contrat
  DateTime startDate;
  DateTime endDate;
  bool canceled;   // will determine if its whether editable or not
  bool planningVariable;
  List<String> validation;  // wether if the contract need geolcation or QR code for validation
  Exceptions _exceptions;
    Contract(this.documentId,this.employerId,this.employeeId,this.libelle,this.description,this.pricePerHour,this.cursorPayment,
        this.startDate,this.endDate,this.canceled,this.employerInfo,this.employeeInfo,this.planningVariable,this.validation);
}

class Exceptions{ // congés payés, arret maladie and those stuff
  String contratId;   // l'id du contrat auquel l'exception est rattaché
  String documentId;
  String origin;   //{employer, employee"} représente l'origine de l'exception: employeur ou employé
  String motif;    // motif
  int price;    // rémunération appliquée pour cette exception
  DateTime startDate; // date de début de l'exception
  DateTime endDate; // date de fin de l'exception

  Exceptions({this.documentId,this.contratId,this.motif,this.price,this.startDate,this.endDate});
}

class Payment{

  String documentId;
  String contratId;
  DateTime startDate;       // début de période concernant le paiement
  DateTime endDate;         // fin de période concernant le paiement
  int cursorPayment;        // curseur sur le numéro actuel de paiement concernant ce contrat
  int workedHour;           // heures éffectuées(validées) par l'employé
  int exceptionsHour;        // cumul des heures par exceptions
  int basicSalary;          // salaire de base basé sur les heures validées et les exceptions faites
  int additionalHour;       // heures complémentaires
  int overtime;             // heures supplémentaires
  int finalSalary;
Payment({this.documentId,this.contratId,this.startDate,this.endDate,this.cursorPayment,
  this.workedHour,this.exceptionsHour,this.basicSalary,this.overtime,this.finalSalary});
}