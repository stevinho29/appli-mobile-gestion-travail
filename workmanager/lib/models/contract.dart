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
  double hourPerWeek;      // nombre d'heures par semaine
  double weeksOfLeave;  // semainde de congés sans solde
  double pricePerHour;
  int trialPeriod;    //période d'essai
  int cursorPayment;    // compteur qui indique combien de factures(fiche de paie) ont deja été délivrées pour ce contrat
  DateTime startDate;
  DateTime endDate;
  bool canceled;   // will determine if its whether editable or not
  bool planningVariable;
  List<String> validation;  // wether if the contract need geolcation or QR code for validation
    Contract(this.documentId,this.employerId,this.employeeId,this.libelle,this.description,this.hourPerWeek,this.weeksOfLeave,this.pricePerHour,this.trialPeriod,this.cursorPayment,
        this.startDate,this.endDate,this.canceled,this.employerInfo,this.employeeInfo,this.planningVariable,this.validation);
}

class Exceptions{ // congés payés, arret maladie and those stuff
  String contratId;   // l'id du contrat auquel l'exception est rattaché
  String documentId;
  String origin;   //{employer, employee"} représente l'origine de l'exception: employeur ou employé
  String motif;    // motif
  double price;    // rémunération appliquée pour cette exception
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
  double workedHour;           // heures éffectuées(validées) par l'employé
  double exceptionsHour;        // cumul des heures par exceptions
  double basicSalary;          // salaire de base basé sur les heures validées et les exceptions faites
  double additionalHour;       // heures complémentaires
  double overtime;             // heures supplémentaires
  double pricePerHour;
  double finalSalary;
Payment({this.documentId,this.contratId,this.startDate,this.endDate,this.cursorPayment,
  this.workedHour,this.exceptionsHour,this.basicSalary,this.overtime,this.pricePerHour,this.finalSalary});
}