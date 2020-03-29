
import 'package:flutter/material.dart';
import 'package:workmanager/models/proposition.dart';




class NewsTile extends StatelessWidget{

  final Proposition propositionsData;
  NewsTile({this.propositionsData});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child:Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              //backgroundColor: Colors.cyan,
              //backgroundImage: ,
            ),
            title: Text(propositionsData.libelle),
            subtitle: Text(propositionsData.price.toString()),
          ),
        ) ,
      ),
      onTap: (){
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropositionMaker(choosedUser: userData)),
        );*/
      },
    );
  }

}

