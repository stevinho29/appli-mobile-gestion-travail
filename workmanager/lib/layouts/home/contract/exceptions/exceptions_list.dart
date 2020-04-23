import 'package:flutter/material.dart';
import 'package:work_manager/models/contract.dart';
import 'exception_tile.dart';
class ExceptionList extends StatefulWidget{

  final Contract contract;
  final List<Exceptions> exceptionList;
  ExceptionList({this.contract,this.exceptionList});
  @override
  State<StatefulWidget> createState() {
    return _ExceptionListState();
  }

}

class _ExceptionListState extends State<ExceptionList>{
  @override
  Widget build(BuildContext context) {

    if(widget.exceptionList.length == 0) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucune exception pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
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