import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/contract/contract_home.dart';
import 'package:work_manager/layouts/home/contract/planning/day/main_day.dart';

import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';



class PlanningTile extends StatefulWidget{

  final Planning planningData;
  Contract contractData;
  PlanningTile({this.planningData,this.contractData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlanningTileState();
  }

}
class _PlanningTileState extends State<PlanningTile>{

Icon indicator= Icon(Icons.fiber_manual_record,color: Colors.amber,);


@override
void initState() {
  super.initState();
  if(widget.planningData.endDate.difference(DateTime.now()).inMilliseconds >0)
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
                        Text("début: ${widget.planningData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .planningData.endDate.toString().split(
                            " ")[0]}"),
                        SizedBox(width: 20,),
                        indicator,
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("consulter",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.calendar_today,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DayOverview(contract: widget.contractData,planning: widget.planningData)),
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
                              if(widget.planningData.startDate.difference(DateTime.now()).inMinutes > 0) {
                                try {
                                  await PlanningDao().deletePlanning(
                                      widget.planningData).then((value) {
                                    Alert().goodAlert(
                                        context, "planning supprimé",
                                        "le planning identifié par ${widget
                                            .planningData
                                            .documentId} a bien été supprimé");
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }else{
                                Alert().badAlert(context, "suppression impossible", "le planning est deja entamé et ne peut etre supprimé");
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
                        Text("début: ${widget.planningData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .planningData.endDate.toString().split(
                            " ")[0]}"),
                        SizedBox(width: 20,),
                        indicator,
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 85),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("consulter ",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.collections,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  DayOverview(contract: widget.contractData,planning: widget.planningData)),
                              );
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

