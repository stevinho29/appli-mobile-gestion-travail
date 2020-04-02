import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/contract/contract_home.dart';

import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';



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
                        Text("heure début: ${widget.dayData.startDate
                            .toString()
                            .split(" ")[0]}        heure fin: ${widget
                            .dayData.endDate.toString().split(
                            " ")[0]}"),
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
                                MaterialPageRoute(builder: (context) => ContractHome(contract: widget.contractData,)),
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
                              try {
                                await PlanningDao().deleteDayOfPlanning(
                                    widget.dayData).then((value) {
                                  Alert().goodAlert(context, "journée supprimée", "la journée identifiée par ${widget.dayData.documentId} a bien été supprimé");
                                });
                              }catch(e){
                                print(e);

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
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("valider ",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.collections,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ContractHome(contract: widget.contractData)),
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

