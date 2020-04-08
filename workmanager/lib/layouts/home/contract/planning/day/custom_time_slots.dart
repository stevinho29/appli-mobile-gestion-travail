import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/services/databases/planningDao.dart';

class CustomTimeSlot extends StatefulWidget{
  Day dayData;
  Contract contract;
  CustomTimeSlot({this.contract,this.dayData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomTimeSlotState();
  }

}

class _CustomTimeSlotState extends State<CustomTimeSlot>{
  List<String> weekday= ['Lundi', 'Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];


  DateTime helperStart;
  DateTime helperEnd;
  String error="";
  @override
  Widget build(BuildContext context) {
    TimeOfDay startHour= TimeOfDay.fromDateTime(widget.dayData.startHour);
    TimeOfDay endHour= TimeOfDay.fromDateTime(widget.dayData.endHour);
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 70,horizontal: 35),
        child: Column(
          children: <Widget>[
            Text(weekday[widget.dayData.startHour.weekday-1]),
            SizedBox(width: 10,),
            Text(DateFormat.yMMMd().format(widget.dayData.startHour)),
            Icon(Icons.watch_later,size: 100,),
            SizedBox(height: 30,),
            Card(
              child: GestureDetector(
                child: ListTile(
                  leading: Text("Début"),
                  title: Center(child: Text(DateFormat.Hm().format(widget.dayData.startHour))),
                  trailing: Icon(Icons.watch_later),
                ),
                onTap: () async {
                  await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(widget.dayData.startHour)).then((value) {
                    setState(() {
                      startHour= value ?? startHour;
                      helperStart= widget.dayData.startHour;

                      widget.dayData.startHour= DateTime(helperStart.year,helperStart.month,helperStart.day,startHour.hour,startHour.minute);

                      print(widget.dayData.startHour);

                    });
                  });
                },
              ),
            ),
                  SizedBox(width: 20,),
            SizedBox(height: 10,),

                  Card(
                    child: GestureDetector(
                      child: ListTile(
                        leading: Text("Fin"),
                        title: Center(child: Text(DateFormat.Hm().format(widget.dayData.endHour))),
                        trailing: Icon(Icons.watch_later),
                      ),
                      onTap: () async {
                        await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(widget.dayData.endHour)).then((value) {
                          setState(() {
                            endHour= value ?? endHour;
                            helperEnd= widget.dayData.endHour;

                            widget.dayData.endHour= DateTime(helperEnd.year,helperEnd.month,helperEnd.day,endHour.hour,endHour.minute);

                            print(widget.dayData.endHour);

                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20,),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                SizedBox(width: 45,),
                Text(error,style: TextStyle(color: Colors.red,fontSize: 13),),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: RaisedButton(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  child: Row(children: <Widget>[
                    SizedBox(width: 15,),
                    Text("valider ",
                        style: TextStyle(color: Colors.black87)),
                    SizedBox(width: 5,),
                    Icon(Icons.check_circle_outline,
                      color: Colors.black87,)
                  ]),
                ),
                onPressed: () {
                  print(startHour.hour);
                  if(startHour.hour - endHour.hour >= 0){
                    setState(() {
                      error= "l'heure de début ne peut etre supérieure\n à l'heure de fin";
                    });
                  }else{
                    setState(() {
                      error= "";
                      Map<String,DateTime> dat= new Map();
                      dat['startHour']= widget.dayData.startHour;
                      dat['endHour']= widget.dayData.endHour;
                      try {
                        PlanningDao().updateDayOfPlanningData(widget.dayData,
                            dat).then((value) {
                              Alert().goodAlert(context, "horaire mis à jour", "l'horaire a bien été mis à jour");

                        });
                        Navigator.pop(context);
                      }catch(e){
                        print(e);
                        Alert().badAlert(context, "l'Opération a échoué", "horaire n'a pas été mis à jour");
                      }
                    });
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: RaisedButton(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  child: Row(children: <Widget>[
                    SizedBox(width: 15,),
                    Text("annuler ",
                        style: TextStyle(color: Colors.black87)),
                    SizedBox(width: 5,),
                    Icon(Icons.cancel,
                      color: Colors.red,)
                  ]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],

        ),
      ),
    );
  }

}