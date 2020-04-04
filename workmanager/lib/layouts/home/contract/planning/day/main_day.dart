import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
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
bool permission;
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user.uid == widget.contract.employerId)
      permission= false;
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
                    padding: EdgeInsets.only(left:20,top: 10,right: 20,bottom: 65),
                    child: DayList(contract: widget.contract,dayList: list,)),
              floatingActionButton: permission ? null:FloatingActionButton.extended(
                onPressed: () async{
                  await  showDatePicker(context: context, initialDate: widget.planning.startDate, firstDate: widget.planning.startDate, lastDate: widget.planning.endDate).then((value) async {

                    if(value != null ){
                      Map<String,DateTime> dat= new Map();
                      dat['startDate']= value;
                      dat['endDate']= value;
                      try{
                        await PlanningDao().checkIfPeriodOfDayAlreadyExist(dat, widget.planning ).then((result) async {
                        if(!result) {
                          await PlanningDao().createDayOfPlanning(
                              widget.planning.documentId, dat, "no QR");
                          Alert().goodAlert(context, "Journée ajoutée",
                              "une journée a été ajoutée au planning");
                        }else{
                          Alert().badAlert(context, "Opération impossible", "un planning qui chevauche ce créneau existe deja");
                        }
                        });
                      }catch(e){
                        print(e);
                        Alert().badAlert(context, "l'Opération a échoué", "une nouvelle journée n'a pas pu etre ajoutée au planning");
                      }
                    }
                 });
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