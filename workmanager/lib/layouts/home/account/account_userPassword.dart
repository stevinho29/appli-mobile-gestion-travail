import 'package:flutter/material.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/services/auth.dart';

import 'package:work_manager/shared/constants.dart';
import 'package:work_manager/shared/loading.dart';

class Password extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PasswordState();
  }

}

class _PasswordState extends State<Password>{

  final AuthService _authService = AuthService();
  final _formKey= GlobalKey<FormState>();

  bool loading= false;
  bool passwordVisible= true;
  String password;
  String cpassword;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return loading ? Loading():Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 45),
          child: Row(children: <Widget>[
            Text("Mot de passe"),
            SizedBox(width: 5,),
            Icon(Icons.visibility_off)
          ]),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "Nouveau mot de passe").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() => passwordVisible = !passwordVisible);
                    },
                  ),
                ),
                obscureText: passwordVisible,
                validator: (val) {
                  return val.isEmpty ? "au moins 6 caractères": null;
                },
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "Confirmer le mot de passe"),
                validator: (val) {
                  return val != this.password ? "mot de passe différents": null;
                },
                obscureText: true,
                onChanged: (val) {
                  setState(() => cpassword = val);
                },
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                child: RaisedButton(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 51),
                      child: Row(children: <Widget>[
                        Icon(Icons.update)
                      ]),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                          setState(() => loading= true);
                         _authService.changePassword(password).then((status) async {
                           print("statut:  $status ");
                           if(status) {
                             await Alert().goodAlert(context, "mise à jour réussie", "le mot de passe a bien été changé");
                             Navigator.pop(context);
                           }
                           else {
                             setState(() => loading = false); // something went wrong
                             Alert().badAlert(context, "mise à jour impossible", "le mot de passe n'a pas pu etre changé\n reconnectez-vous d'abord puis essayez à nouveau ");
                           }
                         });

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