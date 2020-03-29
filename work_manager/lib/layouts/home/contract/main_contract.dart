import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/models/contract.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/databases/contractDao.dart';

import 'contract_list.dart';


class ContractsOverview extends StatefulWidget{
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
    // TODO: implement build
    return StreamBuilder<List<Contract>>(
        stream: ContractDao(uid: user.uid).getContracts,
        builder: (context, snapshot) {
          List list= snapshot.data;
          print("LISTE DE CONTRAT $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Mes Contrats "),
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
  }

}