import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/contract/contract_home.dart';

import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';

import 'modify_time_slots.dart';



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


  @override
  void initState() {
    super.initState();
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
                    SizedBox(height: 2,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.dayData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .dayData.endDate.toString().split(
                            " ")[0]}"),
                        SizedBox(width: 20,),
                        indicator,
                      ],
                    ),
                    SizedBox(height: 15,),
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
                                Icon(Icons.edit,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                              showTimeSlotModificationDialog( context,widget.dayData);
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
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.dayData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .dayData.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 15,),
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
                                Icon(Icons.directions_run,
                                  color: Colors.black87,)
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
                                Icon(Icons.check_circle_outline,
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
      );
    }
  }

}

