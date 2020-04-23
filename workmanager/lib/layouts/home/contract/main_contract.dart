import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';

import 'contract_list.dart';

class ContractsOverview extends StatefulWidget{
  bool isEmployer;
  ContractsOverview({this.isEmployer});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractsOverviewState();
  }

}

class _ContractsOverviewState extends State<ContractsOverview>{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    dynamic employer= StreamBuilder<List<Contract>>(
        stream: ContractDao(uid: user.uid).getContracts,
        builder: (context, snapshot) {
          Widget child1;
          List list= snapshot.data;
          print("LISTE DE CONTRAT $list");
          if (snapshot.hasData) {
              print("SNAPSHOT $snapshot");
            child1=  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Mes Contrats / Employeur"),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ContractList(contractList: list))
            );
          } else if(snapshot.hasError){
            child1= Column(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            );
          }
          else {
            child1=  Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            );
          }
          return child1;
        }
    );

    dynamic employee= FutureBuilder<List<Contract>>(
        future: ContractDao(uid: user.uid).getEmployeeContractsRightNow,
        builder: (context, snapshot) {
          Widget child;
          List secondlist= snapshot.data;
          print("LISTE DE CONTRAT $secondlist");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            child=  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Mes Contrats / prestataire"),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ContractList(contractList: secondlist))
            );
          }else if(snapshot.hasError){
            child= Column(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            );
          }
          else {
            child= Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            );
          }
          return child;
        }
    );
    // TODO: implement build
    return widget.isEmployer ? employer: employee;
  }


}