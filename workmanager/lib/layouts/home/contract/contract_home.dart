import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/contract/planning/day/create_day.dart';
import 'package:work_manager/layouts/home/contract/planning/day/main_day.dart';
import 'package:work_manager/layouts/home/contract/planning/day/seance/main_seance.dart';
import 'package:work_manager/layouts/home/contract/show_contract.dart';
import 'package:work_manager/models/contract.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:work_manager/models/user.dart';

class ContractHome extends StatefulWidget {
  Contract contract;
  ContractHome({this.contract});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractHomeState();
  }
}

class _ContractHomeState extends State<ContractHome>{
  List<String> weekday= ['Lundi', 'Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];
  bool notVariable= false;
  bool permission= false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr-FR');
    if(widget.contract.planningVariable)
        notVariable= false;
    else
      notVariable= true;
  }


  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);
    if(user.uid== widget.contract.employerId)
      permission= true;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60,horizontal: 30),
        child:
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        Text("Contrat N° ${widget.contract.documentId}", style: TextStyle(color: Colors.deepPurple,fontSize: 15),),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Text("Début:"),
                            Text("${weekday[(widget.contract.startDate.weekday-1)]} ${ DateFormat.yMMMMd('fr-FR').format(widget.contract.startDate)}",style: TextStyle(color: Colors.deepPurple,fontSize: 15.5)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Text("Fin: "),
                            Text("${weekday[(widget.contract.endDate.weekday-1)]} ${ DateFormat.yMMMMd('fr-FR').format(widget.contract.endDate)}",style: TextStyle(color: Colors.deepPurple,fontSize: 15.5)),
                          ],
                        ),
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
                      height: notVariable ?150 : !permission ? 210:300.0,
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
                                        vertical: 5, horizontal: 10),
                                    child: Row(children: <Widget>[
                                      Text("termes du contrat",
                                          style: TextStyle(color: Colors.black87)),
                                      SizedBox(width: 50,),
                                      Icon(Icons.collections,
                                        color: Colors.black87,)
                                    ]),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ShowContract(contract: widget.contract)),
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                          Visibility(
                            visible: !notVariable,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20,),
                                Visibility(
                                  visible: permission,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: RaisedButton(
                                          color: Colors.white,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Row(children: <Widget>[
                                              Text(" journée de travail ",
                                                  style: TextStyle(color: Colors.black87)),
                                              SizedBox(width: 10,),
                                              Icon(Icons.calendar_today,
                                                color: Colors.black87,)
                                            ]),
                                          ),
                                          onPressed: () async {

                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(builder: (context) => CreateDay(contract: widget.contract)),
                                               );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: RaisedButton(
                                    color: Colors.white,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Row(children: <Widget>[
                                        Text(" planning en cours ",
                                            style: TextStyle(color: Colors.black87)),
                                        SizedBox(width: 10,),
                                        Icon(Icons.edit,
                                          color: Colors.black87,)
                                      ]),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DayOverview(contract: widget.contract) ),
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
                                       Text(" journées effectives ",
                                      style: TextStyle(color: Colors.black87)),
                                  SizedBox(width: 40,),
                                  Icon(Icons.check_circle_outline,
                                    color: Colors.green,)
                                ]),
                              ),
                              onPressed: () async {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SeanceOverview(contract: widget.contract)),
                                );
                              },
                            ),
                          ),
                              ],
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