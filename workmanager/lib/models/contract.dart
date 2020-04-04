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
  int pricePerHour;
  DateTime startDate;
  DateTime endDate;
  bool canceled;   // will determine if its whether editable or not
  bool planningVariable;
  List<String> validation;  // wether if the contract need geolcation or QR code for validation
  Exceptions _exceptions;
    Contract(this.documentId,this.employerId,this.employeeId,this.libelle,this.pricePerHour,this.startDate,this.endDate,this.canceled,this.employerInfo,this.employeeInfo,this.planningVariable,this.validation);
}

class Exceptions{ // congés payés, arret maladie and those stuff
  String contratId;   // l'id du contrat auquel l'exception est rattaché
  String documentId;
  String motif;    // motif
  int price;    // rémunération appliquée pour cette exception
  DateTime startDate; // date de début de l'exception
  DateTime endDate; // date de fin de l'exception

  Exceptions({this.documentId,this.contratId,this.motif,this.price,this.startDate,this.endDate});
}

