import 'package:flutter/material.dart';
import 'package:workmanager/services/auth.dart';
import 'package:workmanager/shared/constants.dart';




dynamic showSendEmailDialog= (BuildContext context) async {
  final AuthService _authService = AuthService();
  final _forgotFormKey= GlobalKey<FormState>();
  String emailReset='';

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(50.0, 15.0, 10.0, 10.0),
        title: Text('mot de passe oublié'),
        content: SingleChildScrollView(
          child: Form(
            key: _forgotFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val) {
                    return val.isEmpty ? "Entrez un email": null;
                  },
                  onChanged: (val) {
                     emailReset = val;
                  },
                ),
              ],
            ),

          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('envoyer'),
                onPressed: () async {
                  if(_forgotFormKey.currentState.validate()) {
                    await _authService.sendResetPasswordLink(emailReset);
                    Navigator.of(context).pop();
                  }
                },
              ),
              FlatButton(
                child: Text('annuler'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),

        ],
      );
    },
  );
};
