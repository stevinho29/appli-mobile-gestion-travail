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
  bool findable; // whether the user wants to be find by search option or not
  DateTime createdAt; // date when the user joined our community


  UserData({this.uid,this.name,this.surname,this.email,this.rue,this.codePostal,this.tel,this.findable,this.createdAt});
  UserData.light({this.uid,this.name,this.surname,this.email});

}