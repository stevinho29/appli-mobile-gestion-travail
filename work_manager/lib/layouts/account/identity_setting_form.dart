import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/database.dart';
import 'package:workmanager/shared/constants.dart';


class IdentitySetting extends StatefulWidget{

  UserData userData;
  IdentitySetting({this.userData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IdentitySettingState();
  }

}

class _IdentitySettingState extends State<IdentitySetting>{

  final _formKey= GlobalKey<FormState>();

  String _rue;
  String _codePostal;
  Map<String,String> _address= new Map();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
            child: Form(
              key:_formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget.userData.rue ?? 'non renseigné',
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText: "Rue"),
                    validator: (val) {
                          return val.isEmpty ? "veuillez saisir votre rue": null;
                          },
                    onChanged: (val) {
                          setState(() => _rue = val);
                        },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget.userData.codePostal ?? 'non renseigné',
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText: "Code postal"),
                    validator: (val) {
                      return val.isEmpty ? "veuillez saisir votre code postal": null;
                    },
                    onChanged: (val) {
                      setState(() => _codePostal = val);
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                    child: RaisedButton(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(children: <Widget>[
                            Icon(Icons.update)
                          ]),
                        ),
                        onPressed: () async {
                            if(_formKey.currentState.validate()){

                              _address['code_postal']= _codePostal ?? widget.userData.codePostal;
                              _address['rue']= _rue ?? widget.userData.rue;
                              print("code"+ _address['code_postal']);
                              print("rue"+ _address['rue']);
                              await DatabaseService(user.uid).updateUserData(widget.userData.name,widget.userData.surname,widget.userData.email,_address,widget.userData.tel);
                              Navigator.pop(context);
                            }
                        }
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

}
