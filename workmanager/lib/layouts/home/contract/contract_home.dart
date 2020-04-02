import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/contract/planning/create_planning.dart';
import 'package:work_manager/layouts/home/contract/planning/main_planning.dart';
import 'package:work_manager/layouts/home/contract/show_contract.dart';
import 'package:work_manager/models/contract.dart';

class ContractHome extends StatelessWidget{
  Contract contract;
  ContractHome({this.contract});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 100,horizontal: 30),
        child:
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Text("Contrat N° ${contract.documentId}", style: TextStyle(color: Colors.deepPurple,fontSize: 15),),
                        SizedBox(height: 10,),
                        Text("Employeur: ${contract.employerInfo['employerName'].toUpperCase()}",style: TextStyle(color: Colors.deepPurple,fontSize: 15.5)),
                        SizedBox(height: 10,),
                        Text("Prestataire: ${contract.employeeInfo['employeeName'].toUpperCase()}",style: TextStyle(color: Colors.deepPurple,fontSize: 15.5)),
                      ],
                    ),
                  ),

                ),
                Card(

                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {

                    },
                    child: Container(
                      height: 220.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 15,),
                          Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: RaisedButton(
                                  color: Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 30),
                                    child: Row(children: <Widget>[
                                      Text("termes du contrat",
                                          style: TextStyle(color: Colors.black87)),
                                      SizedBox(width: 10,),
                                      Icon(Icons.collections,
                                        color: Colors.black87,)
                                    ]),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ShowContract(contract: contract)),
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Row(children: <Widget>[
                                  Text("créer un nouveau planning ",
                                      style: TextStyle(color: Colors.black87)),
                                  SizedBox(width: 10,),
                                  Icon(Icons.calendar_today,
                                    color: Colors.black87,)
                                ]),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreatePlanning(contract: contract)),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Row(children: <Widget>[
                                  Text("éditer le planning en cours ",
                                      style: TextStyle(color: Colors.black87)),
                                  SizedBox(width: 10,),
                                  Icon(Icons.edit,
                                    color: Colors.black87,)
                                ]),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PlanningOverview(contract: contract) ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }


}