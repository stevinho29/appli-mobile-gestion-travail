import 'package:flutter/material.dart';
import 'package:workmanager/layouts/home/propositions/proposition_tile.dart';
import 'package:workmanager/models/proposition.dart';



class PropositionList extends StatefulWidget{

  List<Proposition> propositionList;
  PropositionList({this.propositionList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PropositionListState();
  }

}

class _PropositionListState extends State<PropositionList>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.propositionList.length == 0){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Text("aucune proposition pour le moment",style: TextStyle(color: Colors.black87,fontSize: 20),),
      );
    }
    else {

      return ListView.builder(
        itemCount: widget.propositionList.length,
        itemBuilder: (context, index) {
          return PropositionTile(propositionsData: widget.propositionList[index]);
        },
      );
    }
  }

}