import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/layouts/alerts/alert.dart';
import 'package:workmanager/layouts/propositions/proposition_setting.dart';
import 'package:workmanager/models/contract.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/databases/contractDao.dart';


class ContractTile extends StatefulWidget{

  final Contract contractData;
  ContractTile({this.contractData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractTileState();
  }

}
class _ContractTileState extends State<ContractTile>{

  bool selected= false;
  
  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(Contract contract){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: PropositionSetting(),
        );
      });
    }

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
                height: selected ? 75.0 : 175.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        //backgroundColor: Colors.cyan,
                        //backgroundImage: ,
                      ),
                      title: Text(widget.contractData.libelle),
                      subtitle: Text(" ${widget.contractData.pricePerHour.toString()} €" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Auteur: ${widget.contractData
                            .employerInfo['employerName'].toUpperCase()} "),
                      ],
                    ),
                    SizedBox(height: 2,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.contractData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .contractData.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("accepter",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.done_outline,
                                  color: Colors.greenAccent,)
                              ]),
                            ),
                            onPressed: () {

                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("refuser",
                                  style: TextStyle(color: Colors.black87),),
                                SizedBox(width: 5,),
                                Icon(Icons.clear, color: Colors.red,)
                              ]),
                            ),
                            onPressed: () async {

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
          /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropositionMaker(choosedUser: userData)),
        );*/
        },
      );
    } else
    {
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {

              },
              child: Container(
                height: selected ? 75.0 : 180.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        //backgroundColor: Colors.cyan,
                        //backgroundImage: ,
                      ),
                      title: Text(widget.contractData.libelle),
                      subtitle: Text(" ${widget.contractData.pricePerHour.toString()} €" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Contacté: ${widget.contractData
                            .employeeInfo['employeeName'].toUpperCase()} "),
                      ],
                    ),
                    SizedBox(height: 2,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.contractData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .contractData.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Statut"),
                        SizedBox(width: 5,),
                      ],
                    ),
                    SizedBox(height: 3,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("annuler ",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.clear,
                                  color: Colors.red,)
                              ]),
                            ),
                            onPressed: () async{
                              try {
                                await ContractDao()
                                    .deleteContract(widget.contractData).then((value){
                                  Alert().goodAlert(context, "Opération réussie", "votre proposition a bien été annulée");
                                });

                              }catch(e){
                                print(e);
                                Alert().badAlert(context, "l'opération a échoué", "votre proposition n'a pas pu etre annulée");
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("modifier",
                                  style: TextStyle(color: Colors.black87),),
                                SizedBox(width: 5,),
                                Icon(Icons.edit, color: Colors.cyan,)
                              ]),
                            ),
                            onPressed: () {
                              _showSettingsPanel(widget.contractData);
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

