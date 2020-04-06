import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:intl/intl.dart';
import 'package:work_manager/layouts/home/contract/planning/day/custom_time_slots.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';
import 'package:work_manager/services/position_validator.dart';





class DayTile extends StatefulWidget{

  final Day dayData;
  Contract contractData;
  DayTile({this.dayData,this.contractData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DayTileState();
  }

}

class _DayTileState extends State<DayTile>{


  Icon indicator= Icon(Icons.fiber_manual_record,color: Colors.amber,);
  List<String> weekday= ['Lundi', 'Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];

  Icon startState= Icon(Icons.check_circle_outline,
    color: Colors.black87,);
  Icon endState= Icon(Icons.check_circle_outline,
    color: Colors.black87,);
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr-FR');
    if(widget.dayData.startValidated)
      startState= Icon(Icons.check_circle_outline,
        color: Colors.green,);
    else
      startState= Icon(Icons.check_circle_outline,
        color: Colors.black87,);

    if(widget.dayData.endValidated)
      endState= Icon(Icons.check_circle_outline,
        color: Colors.green,);
    else
      endState= Icon(Icons.check_circle_outline,
        color: Colors.black87,);

    if(widget.dayData.endDate.difference(DateTime.now()).inMilliseconds >0)
      indicator= Icon(Icons.fiber_manual_record,color: Colors.green);
    else
      indicator= Icon(Icons.fiber_manual_record,color: Colors.amber);

  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final user = Provider.of<User>(context);
    if (widget.contractData.employerId == user.uid) {  //  controle la provenance de la proposition
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {

              },
              child: Container(
                height:  100.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 90,),
                        Text(weekday[widget.dayData.startDate.weekday-1]),
                        SizedBox(width: 7,),
                        Text( new DateFormat.yMMMMd('fr-FR').format(widget.dayData.startDate) ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        Text("début: ${DateFormat.Hm('fr-FR').format(widget.dayData.startDate)}                   fin: ${DateFormat.Hm().format(widget
                            .dayData.endDate)}"),
                        SizedBox(width: 40,),
                        Icon(Icons.calendar_today),
                        indicator,
                      ],
                    ),
                    SizedBox(height: 7,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("plage horaire",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.watch_later,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CustomTimeSlot(contract: widget.contractData,dayData: widget.dayData,)),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("supprimer",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.clear,
                                  color: Colors.red,)
                              ]),
                            ),
                            onPressed: () async {
                              if(widget.dayData.startDate.difference(DateTime.now()).inMinutes > 0) {
                                try {
                                  await PlanningDao().deleteDayOfPlanning(
                                      widget.dayData).then((value) {
                                    Alert().goodAlert(
                                        context, "journée supprimée",
                                        "la journée identifiée par ${widget
                                            .dayData
                                            .documentId} a bien été supprimé");
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }else{
                                Alert().badAlert(context, "suppression impossible", "la journée a deja commencé, suppression impossible");
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  ],
                ),

              ),
            ),
          ),
        ),
        onTap: () {
        },
      );
    } else
    { // il s'agit d'un employé on affiche donc le contrat avec le sinformations de l'mployeur
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {

              },
              child: Container(
                height: 120.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 90,),
                        Text(weekday[widget.dayData.startDate.weekday-1]),
                        SizedBox(width: 7,),
                        Text( new DateFormat.yMMMMd('fr-FR').format(widget.dayData.startDate) ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30,),
                        Text("début: ${DateFormat.Hm().format(widget.dayData.startDate)}                   fin: ${DateFormat.Hm().format(widget
                            .dayData.endDate)}"),
                        SizedBox(width: 30,),
                        Icon(Icons.calendar_today),
                        indicator,
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("arrivée ",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                startState
                              ]),
                            ),
                            onPressed: () {
                              Map<String,DateTime> dat= new Map();
                              dat['startDate']= DateTime.now();
                              dat['endDate']= null;
                              if(!widget.dayData.startValidated) {
                                if (widget.dayData.startDate
                                    .difference(DateTime.now())
                                    .inMinutes > 15 && widget.dayData.endDate
                                    .difference(DateTime.now())
                                    .inMinutes > 15) {
                                  PositionValidator()
                                      .checkIfLocationPermission()
                                      .then((value) {
                                    if (value) {
                                      PositionValidator()
                                          .checkIfLocationIsNearEnough(
                                          widget.contractData
                                              .employerInfo['employerAddress'] +
                                              ' ' + widget.contractData
                                              .employerInfo['employerCodePostal'])
                                          .then((value) async {
                                        if (value) {
                                          widget.dayData.startValidated = true;
                                          try {
                                            await PlanningDao()
                                                .createSeanceOfDay(
                                                widget.dayData, dat, "no QR")
                                                .then((value) {
                                              Alert().goodAlert(
                                                  context, "Arrivée validée",
                                                  "votre heure d'arrivée a bien été prise en compte");
                                              setState(() {
                                                startState = Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,);
                                                widget.dayData.startValidated= false;
                                              });
                                            });
                                          } catch (e) {
                                            print(e);
                                            Alert().badAlert(
                                                context, "l'Opération a échoué",
                                                "votre arrivée n'a pas été prise en compte...veuillez réessayer");
                                          }
                                        } else {
                                          Alert().badAlert(
                                              context, "Validation impossible",
                                              "Vous semblez ne pas etre au domicile de l'employeur ");
                                        }
                                      });
                                    } else {
                                      Alert().badAlert(
                                          context, "Validation impossible",
                                          "Vous devez autorisez l'application à accéder àla localisation pour pouvoir valider ");
                                    }
                                  });
                                } else {
                                  Alert().badAlert(
                                      context, "Validation impossible",
                                      "impossible de valider l'arrivée plus de 15 minutes avant et moins de 15 minutes avant la fin de la séance ");
                                }
                              }else{
                                Alert().badAlert(
                                    context, "Deja validé",
                                    "votre heure d'arrivée a deja été prise en compte ");

                              }
                            },

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("départ ",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                endState
                              ]),
                            ),
                            onPressed: () async {
                              if (!widget.dayData.endValidated) {
                                PositionValidator()
                                    .checkIfLocationPermission()
                                    .then((value) {
                                  if (value) {
                                    PositionValidator()
                                        .checkIfLocationIsNearEnough(
                                        widget.contractData
                                            .employerInfo['employerAddress'] +
                                            ' ' + widget.contractData
                                            .employerInfo['employerCodePostal'])
                                        .then((value) async {
                                      if (value) {
                                        Map<String, DateTime> dat = new Map();
                                        dat['endDate'] = DateTime.now();
                                        try {
                                          await PlanningDao()
                                              .getSeance(widget.dayData)
                                              .then((list) async {
                                            print(" DATE VALID${list[0]
                                                .startDate}");
                                            dat['startDate'] = list[0]
                                                .startDate; // on remet la date de validation à l'arrivée
                                            widget.dayData.endValidated =
                                            true; // on valide le départ
                                            await PlanningDao()
                                                .updateSeanceOfDay(list[0],
                                                widget.dayData, dat, "no QR")
                                                .then((value) {
                                              Alert().goodAlert(
                                                  context, "Départ validé",
                                                  "votre heure de départ a été prise en compte");

                                              setState(() {
                                                endState = Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,);
                                                widget.dayData.endValidated= false;
                                              });
                                            });
                                          });
                                        } catch (e) {
                                          print(e);
                                          Alert().badAlert(
                                              context, "l'Opération a échoué",
                                              "votre heure de départ n'a pas pu etre validée");
                                        }
                                      } else {
                                        Alert().badAlert(
                                            context, "Validation impossible",
                                            "Vous semblez ne pas etre au domicile de l'employeur ");
                                      }
                                    });
                                  } else {
                                    Alert().badAlert(
                                        context, "Validation impossible",
                                        "Vous devez autorisez l'application à accéder àla localisation pour pouvoir valider ");
                                  }
                                });
                              }
                              else {
                                Alert().badAlert(
                                    context, "Deja validé",
                                    "votre heure de départ a deja été prise en compte ");
                              }
                            }
                          ),
                        ),

                      ],
                    ),
                  ],
                ),

              ),
            ),
          ),
        ),
      );
    }
  }

}

