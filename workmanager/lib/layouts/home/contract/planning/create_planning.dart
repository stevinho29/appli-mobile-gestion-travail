
import 'package:flutter/material.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:flutter/scheduler.dart';

import 'package:work_manager/services/databases/planningDao.dart';

class CreatePlanning extends StatefulWidget{

  Contract contract;
  CreatePlanning({this.contract});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatePlanningState();
  }

}
enum Period { oneWeek, twoWeeks}

class _CreatePlanningState extends State<CreatePlanning>{

  final _controller = PageController(
    initialPage: 0,
  );

  Period _period= Period.oneWeek;
  DateTime startDate;
  int _numberOfDays= 7;
  Map<int, bool> choosedDays=new Map();  // jours choisis ou non entre 1 et 14 (Lundi et le prochain Dimanche)
  Map<int,DateTime> choosedDate= new Map();          // les dates des différents jours choisis

  List<String> listOfDays= ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];

  int count=0 ;
  String error="";

  DateTime littleFunction(int day){
    return DateTime(startDate.year,startDate.month,startDate.day+day);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

print(DateTime.now().toString());
  for(int i=1 ; i <= 14;i++) {
    choosedDays[i]= false;
    choosedDate[i]= null;
  }

  print("TEST DE DATE ${DateTime.monday}");
    startDate= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+(7-DateTime.now().weekday+1));
  print("2 TEST DE $startDate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Text("Création d'un planning",style: TextStyle(color: Colors.pinkAccent,fontSize: 20),),
            ),
            Expanded(
              child:PageView(
                controller: _controller,
                onPageChanged: (val) {
                  setState(() {

                  });
                },
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          const BorderRadius.all(const Radius.circular(5.0)),
                          border: new Border.all(
                              color: Colors.pinkAccent,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      child: ListView(
                        children: <Widget>[
                          Center(child: Text("étape 1:",style: TextStyle(fontSize: 20),),),
                          SizedBox(height: 20,),
                          Center(child: Text("Veuillez renseigner la durée du planning")),
                          SizedBox(height: 20,),
                          Card(
                            child: ListTile(
                              title: const Text('1 semaine (7 jours)'),
                              leading: Radio(
                                value: Period.oneWeek ,
                                groupValue: _period,
                                onChanged: (Period value) {
                                  setState(() { _period = value;
                                  _numberOfDays = 7;});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Card(
                            child: ListTile(
                              title: const Text('2 semaines (14 jours)'),
                              leading: Radio(
                                value: Period.twoWeeks ,
                                groupValue: _period,
                                onChanged: (Period value) {
                                  setState(() { _period = value;
                                  _numberOfDays = 14;});
                                },
                              ),
                            ),
                          ),


                        ],
                      )),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(const Radius.circular(5.0)),
                        border: new Border.all(
                            color: Colors.pinkAccent,
                            width: 2.0,
                            style: BorderStyle.solid)),
                    child:
                    ListView.builder(
                        itemCount: _numberOfDays,
                        itemBuilder: (BuildContext context, index){
                          return Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              child: Container(
                                  height:  90.0,
                                  child: Column(
                                      children: <Widget>[
                                        Container(
                                            child:CheckboxListTile(
                                              title:Text(listOfDays[index]) ,
                                              subtitle :Text(littleFunction(index).toString().split(" ")[0]),
                                              value: choosedDays[index+1],
                                              selected: choosedDays[index+1],
                                              onChanged: (bool value) {
                                                setState(() { timeDilation = value ? 2.0 : 1.0;
                                                choosedDays[index+1]= !choosedDays[index+1];});
                                                print("MON INDEX $index");

                                                if(choosedDays[index+1])
                                                  choosedDate[index+1]= littleFunction(index);
                                                else if(choosedDate[index+1] != null)
                                                  choosedDate.remove(index+1);
                                              },
                                            )
                                        ),

                                        Row(
                                          children: <Widget>[
                                            SizedBox(width: 15,),
                                            Text("          début: 8h              fin:12h  "),
                                          ],
                                        ),
                                      ]
                                  )
                              ),
                            ),
                          );
                        }),

                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        const BorderRadius.all(const Radius.circular(5.0)),
                        border: new Border.all(
                            color: Colors.pinkAccent,
                            width: 2.0,
                            style: BorderStyle.solid)),
                    child:Column(
                      children: <Widget>[
                        SizedBox(height: 15,),
                        Center(child: Text("étape 3: validation",style: TextStyle(fontSize: 20),),),
                        SizedBox(height: 10,),
                        Text("vérifiez que c'est bien ce que vous voulez "),
                        SizedBox(height: 15,),
                        Text("- une prévision se fait sur une ou deux semaines "),
                        SizedBox(height: 15,),
                        Text("-gardez à l'esprit que tous planning entammé ne pourra etre supprimé"),
                        SizedBox(height: 15,),
                        Text("-Tout planning débute un lundi et se termine le Dimanche qui vient lorsqu'il s'agit d'une prévision sur une semaine, ou alors le dimanche "
                            "de la semaine d'après pour une prévision sur deux semaines "),
                        SizedBox(height: 15,),
                        Text("en revanche vous pourrez toujours modifier les horaires pour des jours qui ne sont pas encore passés jusqu'à 24 h à l'avance"),
                        SizedBox(height: 20,),
                        Text(error,style: TextStyle(color: Colors.red,fontSize: 15),),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 90),
                              child: RaisedButton(
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Row(children: <Widget>[
                                    Text("valider",
                                        style: TextStyle(color: Colors.black87)),
                                    SizedBox(width: 5,),
                                    Icon(Icons.done,
                                      color: Colors.green,)
                                  ]),
                                ),
                                onPressed: () async {
                                  choosedDays.forEach((key, value) {
                                    if(value == null ){ // on s'assure de ne pas avoir de null pointer
                                      choosedDays[key]= false;
                                    }
                                  });
                                  choosedDays.forEach((key, value)  {   // on vérifie que au moins un jour a été choisi
                                    if (value) {
                                      count++;
                                    }
                                  });
                                  if(count > 0){
                                    setState(() {
                                      error= "";
                                    });
                                    Map<String,DateTime> dat= new Map();
                                    dat['startDate']= startDate;
                                    dat['endDate']= littleFunction(_numberOfDays-1);
                                    try {
                                      await PlanningDao().createPlanning(
                                          widget.contract, dat, choosedDate,
                                          choosedDays).then((value) {
                                         Alert().goodAlert(
                                            context, "planning crée",
                                            "le planning pour les $_numberOfDays suivant a été crée avec succes");
                                         Navigator.pop(context);
                                      });

                                    }catch(e){
                                      print(e);
                                      Alert().goodAlert(
                                          context, "l'Opération a échouée",
                                          "le planning pour les $_numberOfDays suivant n'a pas pu etre crée");
                                      Navigator.pop(context);
                                    }

                                  }
                                  else{
                                    setState(() {
                                      error= "Vous n'avez sélectionné aucune journée dans le planning";
                                    });
                                  }
                                  }
                              ),
                            ),

                          ],
                        ),
                      ],
                    )
                    )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(children: <Widget>[
                        Text("précédent",
                            style: TextStyle(color: Colors.black87)),
                        SizedBox(width: 5,),
                        Icon(Icons.navigate_before,
                          color: Colors.black87,)
                      ]),
                    ),
                    onPressed: () {
                      _controller.previousPage(duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: RaisedButton(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Row(children: <Widget>[
                        Text("suivant ",
                            style: TextStyle(color: Colors.pinkAccent)),
                        SizedBox(width: 5,),
                        Icon(Icons.navigate_next,
                          color: Colors.pinkAccent,)
                      ]),
                    ),
                    onPressed: () {
                      _controller.nextPage(duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,);
                    },
                  ),
                ),

              ],
            ),
            SizedBox(height: 20,),
            Row(children: <Widget>[

            ],),
          ],
        ),
      ),
    );
  }


}