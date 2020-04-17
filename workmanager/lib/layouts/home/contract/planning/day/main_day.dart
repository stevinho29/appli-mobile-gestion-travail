import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';

import 'create_day.dart';
import 'day_list.dart';



class DayOverview extends StatefulWidget{

  Contract contract;
  DayOverview({this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DayOverviewState();
  }

}

class _DayOverviewState extends State<DayOverview>{
bool permission=false;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user.uid == widget.contract.employerId)
      permission= false;
    // TODO: implement build
    return StreamBuilder<List<Day>>(
        stream: PlanningDao().getDaysOfPlanning(widget.contract),
        builder: (context, snapshot) {
          List list= snapshot.data;
          print("LISTE DES JOURNEES $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Jours de travail "),
                ),
                body: Container(
                    padding: EdgeInsets.only(left:20,top: 10,right: 20,bottom: 65),
                    child: DayList(contract: widget.contract,dayList: list,)),
              floatingActionButton: permission ? null:FloatingActionButton.extended(
                onPressed: () async{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateDay(contract: widget.contract) ),
                  );
                },
                label: Text('un jour de plus ?'),
                icon: Icon(Icons.add),
                backgroundColor: Colors.amber,
              ),
            );
          }else
            return Scaffold(
              appBar: AppBar(
                title: Text("Jours de travail"),
              ),
                body:Container(
                  child: Text("AUCUNE JOURNEE PLANIFIEE JUSQUE MAINTENANT"),
                )
            );
        }
    );
  }

}