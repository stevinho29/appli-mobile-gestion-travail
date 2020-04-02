import 'package:flutter/material.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/shared/constants.dart';





dynamic showTimeSlotModificationDialog= (BuildContext context, Day day) async {

  final _forgotFormKey= GlobalKey<FormState>();


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
