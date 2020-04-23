import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/account/identity_setting_form.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/userDao.dart';

class Identity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IdentityState();
  }
}

class _IdentityState extends State<Identity> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // TODO: implement build
    return FutureBuilder<UserData>(
        future: UserDao(user.uid).getUserData(),
        builder: (context, snapshot) {
          Widget scaffold;
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            scaffold= Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Row(children: <Widget>[
                      Text("Identité"),
                      Icon(Icons.person)
              ]),
                ),
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                ],
              ),
                body: ListView(
                  padding: const EdgeInsets.all(10),
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                      border: new Border.all(
                          color: Colors.cyan,
                          width: 2.0,
                          style: BorderStyle.solid)),
                      height: 50,
                  //color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Text('nom: '),
                          Text(userData.name)
                        ],
                  ),
                ),
                    SizedBox(height: 15),
                  Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                            color: Colors.cyan,
                            width: 2.0,
                            style: BorderStyle.solid)),
                    height: 50,
                  //color: Colors.amber[500],
                    child: Row(
                        children: <Widget>[
                          Text('prenom: '),
                          Text(userData.surname)
                    ],
                  ),
                ),
                    SizedBox(height: 15),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                          border: new Border.all(
                              color: Colors.cyan,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      height: 50,
                      //color: Colors.amber[100],
                      child: Row(
                        children: <Widget>[
                          Text('adresse email: '),
                          Text(userData.email)
                    ],
                  ),
                ),
                    SizedBox(height: 15),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                          border: new Border.all(
                              color: Colors.cyan,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      height: 50,
                      //color: Colors.amber[500],
                      child: Row(
                        children: <Widget>[
                          Text('Adresse: '),
                          Text(userData.address == 'null' ? 'non renseigné':userData.address  )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                          border: new Border.all(
                              color: Colors.cyan,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      height: 50,
                      //color: Colors.amber[500],
                      child: Row(
                        children: <Widget>[
                          Text('code postal: '),
                          Text(userData.codePostal == null ? 'non renseigné': userData.codePostal )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(10.0)),
                          border: new Border.all(
                              color: Colors.cyan,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      height: 50,
                      //color: Colors.amber[500],
                      child: Row(
                        children: <Widget>[
                          Text('tel: '),
                          Text( userData.tel == 0 ? "aucun numéro renseigné": userData.tel.toString() )
                        ],
                      ),
                    ),
                      SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                      child: RaisedButton(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Row(children: <Widget>[
                            Text("mettre à jour"),
                            Icon(Icons.update)
                          ]),
                        ),
                        onPressed: () async {
                          await showDialog(context: context,
                              child:AlertDialog(
                                content:  IdentitySetting(userData: userData,),

                              ));

                        }
                      ),
                    )
              ],
            ));
          }else if(snapshot.hasError){
            print("ERROR ${snapshot.hasError}");
          scaffold =
          Scaffold(
            body:Center(
              child: Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
            ) ,

          );
          } else{
            scaffold =
                Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  ),
                );
          }
          return scaffold;
        });
  }
}
