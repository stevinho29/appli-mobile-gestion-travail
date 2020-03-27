import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/layouts/home/account/identity_setting_form.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/databases/userDao.dart';
import 'package:workmanager/shared/loading.dart';

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

    void _showSettingsPanel(UserData userData){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: IdentitySetting(userData: userData),
        );
      });
    }

    // TODO: implement build
    return StreamBuilder<UserData>(
        stream: UserDao(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Scaffold(
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
                          Text((userData.rue +' '+userData.codePostal) ?? "no address" )
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
                          Text('tel: '),
                          Text((userData.tel.toString()) ?? "aucun numéro renseigné" )
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
                          _showSettingsPanel(userData);
                        }
                      ),
                    )
              ],
            ));
          } else {
            return Loading();
          }
        });
  }
}
