import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/contract/planning/planning_tile.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';





class PlanningList extends StatefulWidget{

  List<Planning> planningList;
  Contract contract;
  PlanningList({this.planningList,this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlannignListState();
  }

}

class _PlannignListState extends State<PlanningList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.planningList.length == 0) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucun planning pour ce contrat",style: TextStyle(color: Colors.black87,fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.planningList.length,
        itemBuilder: (context, index) {
          return PlanningTile(planningData: widget.planningList[index],contractData: widget.contract);
        },
      );
    }
  }

}