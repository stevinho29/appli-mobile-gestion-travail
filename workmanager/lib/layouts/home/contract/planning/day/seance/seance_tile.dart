import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';







class SeanceTile extends StatefulWidget{

  final Seance seanceData;
  Contract contractData;
  SeanceTile({this.seanceData,this.contractData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SeanceTileState();
  }

}

class _SeanceTileState extends State<SeanceTile>{


  Icon indicator= Icon(Icons.fiber_manual_record,color: Colors.amber,);
  List<String> weekday= ['Lundi', 'Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];

  Icon startState= Icon(Icons.check_circle_outline,
    color: Colors.green,);
  Icon endState= Icon(Icons.check_circle_outline,
    color: Colors.green,);
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr-FR');
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final user = Provider.of<User>(context);
    if (widget.contractData.employerId != user.uid) {  //  controle la provenance de la proposition
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
                        Text(weekday[widget.seanceData.startHour.weekday-1]),
                        SizedBox(width: 7,),
                        Text( new DateFormat.yMMMMd('fr-FR').format(widget.seanceData.startHour) ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        Text("début: ${DateFormat.Hm('fr-FR').format(widget.seanceData.startHour)}                   fin: ${DateFormat.Hm().format(widget
                            .seanceData.endHour)}"),
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
                        Text(weekday[widget.seanceData.startHour.weekday-1]),
                        SizedBox(width: 7,),
                        Text( new DateFormat.yMMMMd('fr-FR').format(widget.seanceData.startHour) ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 30,),
                        Text("début: ${DateFormat.Hm().format(widget.seanceData.startHour)}                   fin: ${DateFormat.Hm().format(widget
                            .seanceData.endHour)}"),
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
                            onPressed: () {
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
      );
    }
  }

}

