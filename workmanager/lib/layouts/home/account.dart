import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_manager/layouts/home/account/account_userIdentity.dart';
import 'package:work_manager/layouts/home/account/account_userPassword.dart';
import 'package:work_manager/services/auth.dart';


class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<Account> {

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Expanded(
         child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                            color: Colors.cyan,
                            width: 2.0,
                            style: BorderStyle.solid) ),
                      padding: const EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Text("Identité",style: TextStyle(fontSize: 20),),
                        Icon(Icons.person,size: 50,color: Colors.cyan,),
                    ],),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Identity()),
                    );
                  },),
                  Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                            color: Colors.cyan,
                            width: 2.0,
                            style: BorderStyle.solid) ),
                    padding: const EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Text("Préférences",style: TextStyle(fontSize: 20)),
                        Icon(Icons.settings,size: 50,color: Colors.cyan),
                    ],),
                  ),
                    GestureDetector(
                      child:
                      Container(
                        decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                              color: Colors.cyan,
                              width: 2.0,
                              style: BorderStyle.solid) ),
                        padding: const EdgeInsets.all(20),
                        child: Column(children: <Widget>[
                         Text("Sécurité",style: TextStyle(fontSize: 20)),
                         Icon(Icons.lock,size: 50,color: Colors.cyan),
                        ],),
                      ),
                      onTap:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Password()),
                        );
                      },
                  ),
                  GestureDetector(
                    child:Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                        border: new Border.all(
                            color: Colors.cyan,
                            width: 2.0,
                            style: BorderStyle.solid) ),
                    padding: const EdgeInsets.all(20),
                      child: Column(children: <Widget>[
                        Text("deconnexion",style: TextStyle(fontSize: 18)),
                        Icon(Icons.power_settings_new,size: 50,color: Colors.cyan),
                    ],),
                  ),
                    onTap: () async {
                      await _authService.signOut();
                      _deleteSharedPrefs();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        ),
        Row(
          children: <Widget>[
            Expanded(child:Icon(Icons.question_answer,color: Colors.cyan,)),
            Expanded(child:Icon(Icons.lightbulb_outline,color: Colors.cyan)),
            Expanded(child:Icon(Icons.contacts,color: Colors.cyan))
          ],
        )
      ],
    );
  }
}
Future<bool> _deleteSharedPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}