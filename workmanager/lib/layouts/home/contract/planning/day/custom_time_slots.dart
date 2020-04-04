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

  TimeOfDay startHour= TimeOfDay.now();
  TimeOfDay endHour= TimeOfDay.now();
  DateTime helperStart;
  DateTime helperEnd;
  String error="";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 90,horizontal: 35),
        child: Column(
          children: <Widget>[
            Text(weekday[widget.dayData.startDate.weekday-1]),
            SizedBox(width: 10,),
            Text(DateFormat.yMMMd().format(widget.dayData.startDate)),
            Icon(Icons.watch_later,size: 100,),
            SizedBox(height: 30,),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 50,),
                  Card(child: Container(
                    height: 40,
                    width: 60,
                    child: Center(child: Text("début")),
                  ),),
                  SizedBox(width: 40,),
                  Card(child: Container(
                    height: 40,
                    child: GestureDetector(child: Center(child:Text(widget.dayData.startDate.hour.toString() +" H : "+ widget.dayData.startDate.minute.toString()+" m" )),
                        onTap: () async {
                          await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                            setState(() {
                              startHour= value ?? startHour;
                              //widget.dayData.startDate= widget.dayData.startDate.add(new Duration(hours: startHour.hour,minutes: startHour.minute));
                              helperStart= widget.dayData.startDate;

                              widget.dayData.startDate= DateTime(helperStart.year,helperStart.month,helperStart.day,startHour.hour,startHour.minute);

                              print(widget.dayData.startDate);
                            });
                          });

                        }),
                  ),),
                  SizedBox(width: 20,),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 50,),
                   Card(
                     child: Container(
                      height: 40,
                      width: 60,
                      child: Center(child: Text("fin")),
                  ),
                   ),
                  SizedBox(width: 40,),
                  Card(child: Container(
                    height: 40,
                    child: GestureDetector(child: Center(child:Text(widget.dayData.endDate.hour.toString() +" H : "+ widget.dayData.endDate.minute.toString()+" m" )),
                    onTap: () async {
                      await showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                        setState(() {
                        endHour= value ?? endHour;
                        //widget.dayData.endDate= widget.dayData.endDate.add(new Duration(hours: endHour.hour,minutes: endHour.minute));
                        helperEnd= widget.dayData.endDate;

                        widget.dayData.endDate= DateTime(helperEnd.year,helperEnd.month,helperEnd.day,endHour.hour,endHour.minute);

                        print(widget.dayData.endDate);
                        });
                      });

                    },),
                  ),),
                  SizedBox(width: 20,),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: <Widget>[
                SizedBox(width: 45,),
                Text(error,style: TextStyle(color: Colors.red,fontSize: 15),),
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
                      dat['startDate']= widget.dayData.startDate;
                      dat['endDate']= widget.dayData.endDate;
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