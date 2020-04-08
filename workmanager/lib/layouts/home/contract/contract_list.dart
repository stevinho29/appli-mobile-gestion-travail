import 'package:flutter/material.dart';
import 'package:work_manager/models/contract.dart';

import 'contract_tile.dart';




class ContractList extends StatefulWidget{

  List<Contract> contractList;
  ContractList({this.contractList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractListState();
  }

}

class _ContractListState extends State<ContractList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.contractList.length == 0) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucun contrat pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.contractList.length,
        itemBuilder: (context, index) {
          return ContractTile(contractData: widget.contractList[index]);
        },
      );
    }
  }

}