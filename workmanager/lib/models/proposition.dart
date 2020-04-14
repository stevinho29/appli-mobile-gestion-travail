
class Proposition{  // contient des données dénormalisées sur l'employeur et l'employé (representés par une Map senderInfo et une Map receiverInfo dans firestore)



 Map<String,String> senderInfo;
 String senderName;   // nom de l'employeur
 String senderSurname; // prenom de l'employeur
 String senderEmail;   // email de l'amployeur
 String senderAddress;         // adresse de l'employeur
 String senderCodePostal;    // code postal de l'employeur

 Map<String,String> receiverInfo;
 String receiverName;   // nom de l'employé
 String receiverSurname; // prenom de l'employé
 String receiverEmail;   //  email de l'amployé
 String receiverAddress;         // adresse de l'employé
 String reveiverCodePostal;    // code postal de l'employé

 String documentId;
 String  senderId;    // id de l'employeur
 String receiverId;  // id de l'employé
 String libelle;    // libelle de la proposition
 String origin;     // origine de la proposition employeur/prestataire voulant vendre ses services
 String description; // descriptif détaillé de la proposition
 double hourPerWeek;   // nombre d'heures par semaine
 double price;
 DateTime sendDate; // date d'envoi de la proposition
 String status;  // la proposition a t-elle été  ["en attente", "REJETE", "ACCEPTE"]
 bool visible;  // proposition est elle visible(affichable) ou pas
 Map<String,DateTime> dat;  // date de début et de fin du contrat
 bool planningVariable;

 Proposition({this.documentId,this.senderId,this.receiverId,this.libelle,this.origin,this.description,this.hourPerWeek,this.price,this.sendDate,this.status,this.visible,this.dat,this.senderInfo,this.receiverInfo,this.planningVariable});



}