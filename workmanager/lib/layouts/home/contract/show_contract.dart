import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/home/contract/Exception_in_contract.dart';
import 'package:work_manager/layouts/home/contract/exceptions/main_exceptions.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/services/pdf.dart';

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

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    void _showSettingsPanel(Contract contract){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: ContractSetting(contractData: contract),
        );
      });
    }

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
              onTap: (){
                _showSettingsPanel(widget.contract);
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
              leading: Icon(Icons.file_download),
              title: Text('télécharger au format pdf'),
              onTap: () async {
                await Permission.storage.request().then((status) {
                  if(status == PermissionStatus.undetermined || status == PermissionStatus.denied ){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestingPermission()),
                    );
                  }
                });

              }
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('annuler le contrat'),
              onTap: () async {
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
                        Text("non renseigné"),
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