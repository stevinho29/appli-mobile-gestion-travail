import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';

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
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // TODO: implement build
    return StreamBuilder<List<Planning>>(
        stream: PlanningDao().getPlanning(widget.contract),
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
                    padding: EdgeInsets.all(20),
                    child: DayList(contract: widget.contract,dayList: list,))
            );
          }else
            return Scaffold(
                body:Container(
                  child: Text("AUCUNE JOURNEE PLANIFIEE JUSQUE MAINTENANT"),
                )
            );
        }
    );
  }

}