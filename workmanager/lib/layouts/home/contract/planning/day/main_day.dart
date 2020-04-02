import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';

import 'day_list.dart';



class DayOverview extends StatefulWidget{
  Planning planning;
  Contract contract;
  DayOverview({this.contract,this.planning});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DayOverviewState();
  }

}

class _DayOverviewState extends State<DayOverview>{

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // TODO: implement build
    return StreamBuilder<List<Day>>(
        stream: PlanningDao().getDaysOfPlanning(widget.planning),
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
                    padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                    child: DayList(contract: widget.contract,dayList: list,)),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {

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