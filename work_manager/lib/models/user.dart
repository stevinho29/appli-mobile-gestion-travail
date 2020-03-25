class User{

  String uid;
  User({this.uid});

}

class UserData{
  String uid;
  String name;
  String surname;
  String email;
  String rue ;
  String codePostal;
  int tel;



  UserData({this.uid,this.name,this.surname,this.email,this.rue,this.codePostal,this.tel});
  UserData.light({this.uid,this.name,this.surname,this.email});

}