import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/contract/main_contract.dart';
import 'package:work_manager/layouts/home/work/search_station.dart';

class Work extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WorkState();
  }

}

class _WorkState extends State<Work>{
  bool isEmployer;
  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          GestureDetector(
          child:Container(
            height: 150,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                border: new Border.all(
                    color: Colors.cyan,
                    width: 2.0,
                    style: BorderStyle.solid) ),
            padding: EdgeInsets.all(20) ,
            child: Column(
              children: <Widget>[
                Text("Employeur",style: TextStyle(fontSize: 20)),
                SizedBox(height: 5,),
                Icon(Icons.supervised_user_circle,color: Colors.cyan,),
                SizedBox(height: 5,),
                Text("mes contrats,périodes....je bosse avec qui deja ?",style: TextStyle(fontSize: 13),)
              ],
            ),
          ),
            onTap: (){
            isEmployer= true;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContractsOverview(isEmployer: isEmployer,)),
              );
            },
          ),
          SizedBox(height: 10,),
          GestureDetector(
          child:Container(
            height: 150,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                border: new Border.all(
                    color: Colors.cyan,
                    width: 2.0,
                    style: BorderStyle.solid) ),
            padding: EdgeInsets.all(20) ,
            child: Column(
              children: <Widget>[
                Text("Employé",style: TextStyle(fontSize: 20)),
                SizedBox(height: 5,),
                Icon(Icons.work,color: Colors.cyan,),
                SizedBox(height: 5,),
                Text("silence.....je bosse",style: TextStyle(fontSize: 13),)
              ],
            ),
          ),
            onTap: (){
              isEmployer= false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContractsOverview(isEmployer: isEmployer,)),
              );
            },
          ),
          SizedBox(height: 10,),
          GestureDetector(
            child:Container(
            height: 150,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
                border: new Border.all(
                    color: Colors.cyan,
                    width: 2.0,
                    style: BorderStyle.solid) ),
            padding: EdgeInsets.all(20) ,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5,),
                Icon(Icons.search,color: Colors.cyan,size: 70,),
                Text("Looking for someone to hire",style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
            onTap: (){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchStation()),
            );},
          )
        ],
      ),
    )
    ;
  }

}