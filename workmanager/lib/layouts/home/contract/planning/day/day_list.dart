import 'package:flutter/material.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';

import 'day_tile.dart';





class DayList extends StatefulWidget{

  List<Day> dayList;
  Contract contract;
  DayList({this.dayList,this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DayListState();
  }

}

class _DayListState extends State<DayList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.dayList == null) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucune journée déclarée pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.dayList.length,
        itemBuilder: (context, index) {
          return DayTile(contractData: widget.contract,dayData: widget.dayList[index],);
        },
      );
    }
  }

}