
class Proposition{  // contient des données dénormalisées sur l'employeur et l'employé (representés par une Map senderInfo et une Map receiverInfo dans firestore)



 Map<String,String> senderInfo;
 String senderName;   // nom de l'employeur
 String senderSurname; // prenom de l'employeur
 String senderEmail;   // email de l'amployeur

 Map<String,String> receiverInfo;
 String receiverName;   // nom de l'employé
 String receiverSurname; // prenom de l'employé
 String receiverEmail;   //  email de l'amployé

 String documentId;
 String  senderId;    // id de l'employeur
 String receiverId;  // id de l'employé
 String libelle;    // libelle de la proposition
 int price;
 DateTime sendDate; // date d'envoi de la proposition
 String status;  // la proposition a t-elle été  ["en attente", "REJETE", "ACCEPTE"]
 bool visible;  // proposition est elle visible(affichable) ou pas
 Map<String,DateTime> dat;  // date de début et de fin du contrat
 Proposition({this.documentId,this.senderId,this.receiverId,this.libelle,this.price,this.sendDate,this.status,this.visible,this.dat,this.senderInfo,this.receiverInfo});



}