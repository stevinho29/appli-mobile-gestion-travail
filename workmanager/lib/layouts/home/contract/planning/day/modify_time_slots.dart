import 'package:flutter/material.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';




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
          child:  FlatButton(
              onPressed: () {
                DatePicker.showTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                    }, currentTime: DateTime.now());
              },
              child: Text(
                'show time picker',
                style: TextStyle(color: Colors.blue),
              )),
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
