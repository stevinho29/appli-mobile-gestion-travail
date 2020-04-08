import 'package:flutter/material.dart';
import 'package:work_manager/models/contract.dart';
import 'exception_tile.dart';




class ExceptionList extends StatefulWidget{

  Contract contract;
  List<Exceptions> exceptionList;
  ExceptionList({this.contract,this.exceptionList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExceptionListState();
  }

}

class _ExceptionListState extends State<ExceptionList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.exceptionList == null) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucun contrat pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.exceptionList.length,
        itemBuilder: (context, index) {
          return ExceptionTile(contract: widget.contract,exceptionData: widget.exceptionList[index]);
        },
      );
    }
  }

}