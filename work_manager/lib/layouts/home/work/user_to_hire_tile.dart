
import 'package:flutter/material.dart';
import 'package:workmanager/models/user.dart';


class ItemSearchTile extends StatelessWidget{

  final UserData userData;
  ItemSearchTile({this.userData});

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
            title: Text(userData.name),
            subtitle: Text(userData.surname),
          ),
        ) ,
      ),
      onTap: (){

      },
    );
  }

}

