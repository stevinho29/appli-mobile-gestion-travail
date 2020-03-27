class Contracts{

  //String uid;
  String employerId;
  String employeeId;
  String libelle;
  int pricePerHour;
  DateTime startDate;
  DateTime endDate;
  bool validate;   // will determine if its whether editable or not
  Exceptions _exceptions;

}

class Exceptions{ // congés payés, arret maladie and those stuff
  String contratId;   // l'id du contrat auquel l'exception est rattaché
  String libelle;    // motif
  DateTime startDate; // date de début de l'exception
  DateTime endDate; // date de fin de l'exception

  Exceptions({this.libelle,this.startDate,this.endDate});
}