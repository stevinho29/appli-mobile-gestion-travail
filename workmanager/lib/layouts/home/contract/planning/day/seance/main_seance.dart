import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/contract/planning/day/seance/seance_list.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/services/databases/planningDao.dart';


class SeanceOverview extends StatefulWidget{

  Contract contract;
  SeanceOverview({this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SeanceOverviewState();
  }

}

class _SeanceOverviewState extends State<SeanceOverview>{
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
    //if(user.uid == widget.contract.employerId)
    // TODO: implement build
    return StreamBuilder<List<Seance>>(
        stream: PlanningDao().getAllSeance(),
        builder: (context, snapshot) {
          List list= snapshot.data;
          print("LISTE DES JOURNEES EFFECTUEES $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Journées validées "),
              ),
              body: Container(
                  padding: EdgeInsets.only(left:20,top: 10,right: 20,bottom: 65),
                  child: SeanceList(contract: widget.contract,seanceList: list,)),
            );
          }else
            return Scaffold(
                appBar: AppBar(
                  title: Text("Jours de travail"),
                ),
                body:Container(
                  child: Text("AUCUNE JOURNEE VALIDEE JUSQUE MAINTENANT"),
                )
            );
        }
    );
  }

}