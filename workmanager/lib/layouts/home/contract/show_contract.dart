import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/contract/Exception_in_contract.dart';
import 'package:work_manager/layouts/home/contract/exceptions/main_exceptions.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';


import 'contract_setting.dart';


class ShowContract extends StatefulWidget{

  Contract contract;
  ShowContract({this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowContractState();
  }

}

class _ShowContractState extends State<ShowContract>{

  double sliderValue;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:  <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  'Panneau de control',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Modifier les termes du contrat'),
              onTap: () async {
                if(widget.contract.startDate.difference(DateTime.now()).inHours <= 0) {
                  await showDialog(context: context,
                      child: AlertDialog(
                        content: ContractSetting(contractData: widget.contract),

                      ));
                }else{
                  Alert().badAlert(context, "Modification impossible", "il est impossible de modifier les termes d'un contrat une fois entamé ");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Déclarer des jours exceptionnels\n'
                  'congés, arret maladie'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateException(contract: widget.contract)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Liste d\'exceptions deja déclarée'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExceptionsOverview(contract: widget.contract)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Semaines de Congés sans solde:   ${widget.contract.weeksOfLeave.floor().toString()}  semaines'),
              onTap: (){
                showModalBottomSheet(context: context, builder: (context){

                  return Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15,),
                        Text("mise à jour congés sans solde",style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        Slider(
                          value: sliderValue ?? widget.contract.weeksOfLeave,
                          activeColor: Colors.cyan,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          onChanged: (val) {
                            setState(() {
                              sliderValue= val.floorToDouble();
                            });
                          },
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 20,),
                            Text("nombre de semaines:"),
                            SizedBox(width: 10,),
                            Text(sliderValue?.toString() ?? widget.contract.weeksOfLeave.toString(),style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 100),
                          child: RaisedButton(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Row(children: <Widget>[
                                  Icon(Icons.update)
                                ]),
                              ),
                              onPressed: () async {
                                if(widget.contract.employerId == user.uid) {
                                  try {
                                    await ContractDao(uid: user.uid)
                                        .updateContractWeeksOfLeave(
                                        widget.contract, sliderValue);
                                    Alert()
                                        .goodAlert(
                                        context, "Mise à jour réussie",
                                        "le nombre de semaines de congés sans solde a bien été mis à jour")
                                        .then((value) {
                                      Navigator.pop(context);
                                      setState(() {
                                      });
                                    });
                                  } catch (e) {
                                    print(e);
                                    Alert()
                                        .badAlert(
                                        context, "l'opération a échoué",
                                        "une erreur s'est produite lors de la mise à jour..veuillez réessayer plus tard")
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  }
                                }else{
                                  Alert().badAlert(context, "Permission refusée", "Seul l'employeur peut modifier les semaines de congés sans solde");
                                }
                              }
                          ),
                        )
                      ],
                    ),

                  );
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('télécharger au format pdf'),
              onTap: () async {
                if(Platform.isAndroid)
                  Alert().badAlert(context, "À venir", "cette fonctionnalité sera implémentée sous peu...");
                else
                  Alert().badAlertIos(context, "À venir", "cette fonctionnalité sera implémentée sous peu...");
    /*  await Permission.storage.request().then((status) {
                  if(status == PermissionStatus.undetermined || status == PermissionStatus.denied ){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestingPermission()),
                    );
                  }
                });
*/
              }
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('annuler le contrat'),
              onTap: () async {
                await showDialog(context: context,
                child: AlertDialog(
                  title: Text("              Important"),
                  content: Text("l'annulation d'un contrat est une opération irréversible qui entraine son archivage\n "
                      "et l'arret des fonctions de calcul et de suivi"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('annuler'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('continuer'),
                      onPressed: () async {
                        try {
                          await ContractDao(uid: user.uid).cancelContract(widget.contract).then((value) {
                            Alert().goodAlert(context, "Annulatiuon réussie", "le contrat a bien été annulé");
                          });
                        }catch(e){
                          print(e);
                          Alert().badAlert(context, "l'Opération a échoué", "le contrat n'a pas pu etre annulé");
                        }
                      },
                    ),
                  ],
                ));

              },
            ),
            ListTile(
              leading: Icon(Icons.clear),
              title: Text('Fermer le panneau de control'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
              border: new Border.all(
                  color: Colors.cyan,
                  width: 2.0,
                  style: BorderStyle.solid) ),
          child: ListView(
            children: <Widget>[
              Center(child: Text("Apercu du contrat de travail",style: TextStyle(color: Colors.cyan,fontSize: 20),)),
              SizedBox(height: 20,),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Poste occupé par le prestataire:",style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text(widget.contract.libelle),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Qualifications du prestataire",style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text(widget.contract.libelle)
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              SizedBox(height: 15,),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Durée du travail",style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.contract.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .contract.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Période d'essai: ",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 10,),
                        Text("${widget.contract.trialPeriod.toString()} semaines"),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Durée minimale",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 10,),
                        Text("non renseigné"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.black87,
              ),
              SizedBox(height: 15,),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Rémunération horaire:",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 10,),
                        Text("${widget.contract.pricePerHour} € / heure "),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Compositions de la rémunération:",style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text("Le calcul  des heures se font essentiellement via l'application do..it\n"
                        "conformément aux conditions générales de la plateforme et de la réglémentation en vigueur"),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Mode de communication des horaires du salarié:",style: TextStyle(color: Colors.red),),
                        ],
                    ),
                    SizedBox(height: 10,),
                    Text("la communication des heures se font essentiellement via l'application do..it\n"
                        "conformément aux conditions générales de la plateforme et de la réglémentation en vigueur")

                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

}