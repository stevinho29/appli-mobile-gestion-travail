class Contract{  // contient des données dénormalisées sur l'employeur et l'employé (representés par une Map employerInfo et une Map employeeInfo dans firestore)

  Map<String,String> employerInfo;
  String employerName;   // nom de l'employeur
  String employerSurname; // prenom de l'employeur
  String employerEmail;   // email de l'amployeur

  Map<String,String> employeeInfo;
  String employeeName;   // nom de l'employé
  String employeeSurname; // prenom de l'employé
  String employeeEmail;   //  email de l'amployé
  
  String documentId;
  String employerId;
  String employeeId;
  String libelle;
  int pricePerHour;
  DateTime startDate;
  DateTime endDate;
  bool validate;   // will determine if its whether editable or not
  Exceptions _exceptions;
    Contract(this.documentId,this.employerId,this.employeeId,this.libelle,this.pricePerHour,this.startDate,this.endDate,this.validate,this.employerInfo,this.employeeInfo);
}

class Exceptions{ // congés payés, arret maladie and those stuff
  String contratId;   // l'id du contrat auquel l'exception est rattaché
  String libelle;    // motif
  DateTime startDate; // date de début de l'exception
  DateTime endDate; // date de fin de l'exception

  Exceptions({this.libelle,this.startDate,this.endDate});
}