import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/contract/planning/day/seance/seance_tile.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';







class SeanceList extends StatefulWidget{

  List<Seance> seanceList;
  Contract contract;
  SeanceList({this.seanceList,this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SeanceListState();
  }

}

class _SeanceListState extends State<SeanceList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.seanceList == null) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all( 60),
          child: Text("aucune journée validée pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.seanceList.length,
        itemBuilder: (context, index) {
          return SeanceTile(contractData: widget.contract,seanceData: widget.seanceList[index],);
        },
      );
    }
  }

}