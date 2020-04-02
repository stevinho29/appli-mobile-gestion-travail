import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/planningDao.dart';

import 'PlanningList.dart';

class PlanningOverview extends StatefulWidget{
  Contract contract;
  PlanningOverview({this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlanningOverviewState();
  }

}

class _PlanningOverviewState extends State<PlanningOverview>{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // TODO: implement build
    return StreamBuilder<List<Planning>>(
        stream: PlanningDao().getPlanning(widget.contract),
        builder: (context, snapshot) {
          List list= snapshot.data;
          print("LISTE DE PLANNING $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Mes Plannings "),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: PlanningList(planningList: list,contract: widget.contract))
            );
          }else
            return Scaffold(
                body:Container(
                  child: Text("AUCUN PLANNING JUSQUE MAINTENANT"),
                )
            );
        }
    );
  }

}