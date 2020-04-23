import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/propositions/proposition_setting.dart';
import 'package:work_manager/models/proposition.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/propositionDao.dart';

class PropositionTile extends StatefulWidget{

  final Proposition propositionsData;
  PropositionTile({this.propositionsData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PropositionsTileState();
  }

}
class _PropositionsTileState extends State<PropositionTile>{

  bool selected= true;
  String statut;
  @override
  void initState() {
  super.initState();
  if(widget.propositionsData.origin== "employer")
    statut= "employé";
  else
    statut= "employeur";
  }

  @override
  Widget build(BuildContext context) {

    /*void _showSettingsPanel(Proposition proposition){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: PropositionSetting(propositionData: proposition),
        );
      });
    }*/

    // TODO: implement build
    final user = Provider.of<User>(context);
    if (widget.propositionsData.receiverId == user.uid) {  //  controle la provenance de la proposition
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
                      title: Text(widget.propositionsData.libelle),
                      subtitle: Text(" ${widget.propositionsData.price.toString()} €" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: !selected,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("Recu de: ${widget.propositionsData
                                  .senderInfo['senderName'].toUpperCase()}      fonction:$statut"),
                            ],
                          ),
                          SizedBox(height: 2,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("début: ${widget.propositionsData.dat['startDate']
                                  .toString()
                                  .split(" ")[0]}        fin: ${widget
                                  .propositionsData.dat['endDate'].toString().split(
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
                                    if (widget.propositionsData
                                        .dat['startDate']
                                        .difference(DateTime.now())
                                        .inHours >= 0) {
                                    try {
                                        PropositionDao(uid: user.uid)
                                            .acceptProposition(
                                            widget.propositionsData);
                                        Alert().goodAlert(
                                            context, "Proposition acceptée",
                                            "le contrat sera crée conformément aux termes ");
                                      } catch (e) {
                                      print(e);
                                      Alert().badAlert(
                                          context, "problème survenu",
                                          "l'opération n'a pas pu etre éffectuée...");
                                    }
                                  }else{
                                      Alert().badAlert(
                                          context, "Opération impossible",
                                          "la date de début de contrat spécifiée dans cette proposition est deja passée...");
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
                                      Text("refuser",
                                        style: TextStyle(color: Colors.black87),),
                                      SizedBox(width: 5,),
                                      Icon(Icons.clear, color: Colors.red,)
                                    ]),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await PropositionDao(uid: user.uid)
                                          .refuseProposition(widget.propositionsData).then((value){
                                            Alert().goodAlert(context, "Opération réussie", "la proposition a bien été rejetée");
                                      });

                                    }catch(e){
                                      print(e);
                                      Alert().badAlert(context, "problème survenu", "l'opération n'a pas pu etre éffectuée...");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                      title: Text(widget.propositionsData.libelle),
                      subtitle: Text(" ${widget.propositionsData.price.toString()} € / heure" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: !selected,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("Contacté: ${widget.propositionsData
                                  .receiverInfo['receiverName'].toUpperCase()}     fonction: $statut"),
                            ],
                          ),
                          SizedBox(height: 2,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("début: ${widget.propositionsData.dat['startDate']
                                  .toString()
                                  .split(" ")[0]}        fin: ${widget
                                  .propositionsData.dat['endDate'].toString().split(
                                  " ")[0]}"),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("Statut"),
                              SizedBox(width: 5,),
                              Text(widget.propositionsData.status,style: TextStyle(color: Colors.green),),
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
                                      await PropositionDao(uid: user.uid)
                                          .deleteProposition(widget.propositionsData).then((value){
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
                                  onPressed: () async {
                                    await showDialog(context: context,
                                    child:AlertDialog(
                                    content:  PropositionSetting(propositionData: widget.propositionsData,),

                                    ));

                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

