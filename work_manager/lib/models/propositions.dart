
class Propositions{

 String  senderId;    // id de l'employeur
 String receiverId;  // id de l'employé
 String libelle;    // libelle de la proposition
 DateTime sendDate; // date d'envoi de la proposition
 bool status;  // la proposition a t-elle été acceptée
 bool visible;  // proposition est elle visible(affichable) ou pas
 Map<DateTime,DateTime> dates;
 Propositions({this.senderId,this.receiverId,this.libelle,this.sendDate,this.status,this.visible,this.dates});

}