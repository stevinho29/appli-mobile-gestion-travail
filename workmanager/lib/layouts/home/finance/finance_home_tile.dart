import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';



class FinanceHomeTile extends StatefulWidget{

  Contract contractData;
  FinanceHomeTile({this.contractData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FinanceHomeTileState();
  }

}
class _FinanceHomeTileState extends State<FinanceHomeTile>{

  bool selected= false;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build

  //  controle la provenance de la proposition
      return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(" ${widget.contractData.libelle}",style: TextStyle(fontSize: 20),),
                ],
              ),
              SizedBox(height: 10,),
              Card(
                child: Container(
                    width: 400,

                  child: Column(
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text("Période  en  cours:")),
                              SizedBox(width: 15,),
                              Icon(Icons.payment,color: Colors.cyan[100],),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.0,
                        color: Colors.cyan[100],
                      ),
                      GestureDetector(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Text("fiches de paie")),

                                  SizedBox(width: 15,),
                                  Icon(Icons.euro_symbol,color:Colors.cyan[100]),
                                ],

                              ),
                            ),
                          ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.0,
                        color: Colors.cyan[100],
                      ),
                      GestureDetector(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text("payer")),
                                SizedBox(width: 50,),
                                Icon(Icons.call_to_action,color: Colors.cyan[100],),
                              ],

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
              ),
              SizedBox(height: 5,),
            ],
          ),

      );

  }

}

