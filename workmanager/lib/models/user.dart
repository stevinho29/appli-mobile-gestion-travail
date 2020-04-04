class User{

  String uid;
  User({this.uid});

}

class UserData{
  String uid;
  String name;
  String surname;
  String email;
  String address ;
  String codePostal;
  int tel;
  bool findable; // whether the user wants to be find by search option or not
  DateTime createdAt; // date when the user joined our community
  Token userToken;


  UserData({this.uid,this.name,this.surname,this.email,this.address,this.codePostal,this.tel,this.findable,this.createdAt});
  UserData.light({this.uid,this.name,this.surname,this.email});

}

class Token{
  DateTime createdAt;
  String token;     // needed to send individual notification to this user
  String platform;
}