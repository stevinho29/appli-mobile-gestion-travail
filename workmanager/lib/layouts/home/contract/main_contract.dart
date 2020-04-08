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
          List list= snapshot.data;
          print("LISTE DE CONTRAT $list");
          if (snapshot.hasData) {
            try {
              print("SNAPSHOT $snapshot");
            }catch(e){print(e);}
            return  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Mes Contrats / Employeur"),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ContractList(contractList: list))
            );
          }else
            return Scaffold(
                body:Container(
                  child: Text("NO PROPOSITIONS SO FAR"),
                )
            );
        }
    );
    dynamic employee= StreamBuilder<List<Contract>>(
        stream: ContractDao(uid: user.uid).getEmployeeContracts,
        builder: (context, snapshot) {
          List secondlist= snapshot.data;
          print("LISTE DE CONTRAT $secondlist");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Mes Contrats / prestataire"),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ContractList(contractList: secondlist))
            );
          }else
            return Scaffold(
                body:Container(
                  child: Text("NO PROPOSITIONS SO FAR"),
                )
            );
        }
    );
    // TODO: implement build
    return widget.isEmployer ? employer: employee;
  }


}