import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/services/databases/planningDao.dart';
import 'package:intl/date_symbol_data_local.dart';

class CreateDay extends StatefulWidget{
  Contract contract;
  CreateDay({this.contract});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateDayState();
  }

}

class _CreateDayState extends State<CreateDay>{
  List<String> weekday= ['Lundi', 'Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];



  DateTime helperStart= DateTime.now();
  DateTime helperEnd= DateTime.now();
  TimeOfDay startHour= TimeOfDay.now();
  TimeOfDay endHour= TimeOfDay.now();
  DateTime currentDate= DateTime.now();
  String error="";


  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr-FR');
  }

  @override
  Widget build(BuildContext context) {



    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 70,horizontal: 35),
        child: Column(
          children: <Widget>[
            Icon(Icons.event,size: 100,),
            SizedBox(height: 20,),
            Card(
              child: GestureDetector(
                child: ListTile(
                  leading: Text("Jour"),
                  title: Row(
                    children: <Widget>[
                      Text(weekday[currentDate.weekday-1]),
                      SizedBox(width: 3,),
                      Text(DateFormat.yMMMMd('fr-FR').format(currentDate),style: TextStyle(fontSize: 15),),
                    ],
                  ),
                  trailing: Icon(Icons.calendar_today),
                ),
                onTap: () async{
                await showDatePicker(context: context, initialDate: DateTime.now().add(Duration(days: 1)), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 13))).then((value) {

                  setState(() {
                    currentDate = value ?? currentDate;
                  });
                });
                },
              ),
            ),
            Card(
              child: GestureDetector(
                child: ListTile(
                  leading: Text("Arrivée"),
                  title: Center(child: Text(DateFormat.Hm().format(helperStart))),
                  trailing: Icon(Icons.watch_later),
                ),
                onTap: () async {
                  await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                      setState(() {
                        startHour= value ?? startHour;
                        helperStart= DateTime(currentDate.year,currentDate.month,currentDate.day,startHour.hour,startHour.minute);

                      });

                      });
                  }
              ),
            ),
            Card(
              child: GestureDetector(
                child: ListTile(
                  leading: Text("Départ"),
                  title: Center(child: Text(DateFormat.Hm().format(helperEnd))),
                  trailing: Icon(Icons.watch_later),
                ),
                onTap: () async {
                  await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                    setState(() {
                      endHour= value ?? endHour;
                      helperEnd= DateTime(currentDate.year,currentDate.month,currentDate.day,endHour.hour,endHour.minute);

                    });
                  });
                },
              ),
            ),
            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                SizedBox(width: 45,),
                Text(error,style: TextStyle(color: Colors.red,fontSize: 10),),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: RaisedButton(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  child: Row(children: <Widget>[
                    SizedBox(width: 15,),
                    Text("valider ",
                        style: TextStyle(color: Colors.black87)),
                    SizedBox(width: 5,),
                    Icon(Icons.check_circle_outline,
                      color: Colors.black87,)
                  ]),
                ),
                onPressed: () async {
                  print(startHour);

                  if (helperEnd
                      .difference(helperStart)
                      .inHours <= 0) {
                    setState(() {
                      error =
                      "l'heure de début ne peut etre supérieure\n ou égale à l'heure de fin";
                    });
                  } else {
                    Map<String, DateTime> dat = new Map();
                    dat['startHour'] = helperStart;
                    dat['endHour'] = helperEnd;


                    try {
                       PlanningDao().checkIfPeriodOfDayAlreadyExist(
                          dat, widget.contract).then((result) async {
                        if (!result) {
                           PlanningDao().createDayOfPlanning(
                              widget.contract.documentId, dat, "no QR").then((
                              value) {
                            Alert().goodAlert(
                                context, "le jour de travail crée",
                                "vous avez déclaré avec succès un jour de travail ");
                          });
                          Navigator.pop(context);
                        } else {
                          Alert().badAlert(context, "Opération impossible",
                              "un horaire qui chevauche ce créneau existe deja");
                        }
                      });
                    } catch (e) {
                      print(e);
                      Alert().badAlert(context, "l'Opération a échoué",
                          "une nouvelle journée n'a pas pu etre ajoutée au planning");
                    }

                  }
                })),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Row(children: <Widget>[
                        SizedBox(width: 15,),
                        Text("annuler ",
                            style: TextStyle(color: Colors.black87)),
                        SizedBox(width: 5,),
                        Icon(Icons.cancel,
                          color: Colors.red,)
                      ]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                     )
                )
          ],
        ),
      ),
    );
  }

}