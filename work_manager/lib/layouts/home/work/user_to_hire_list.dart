import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/layouts/home/work/user_to_hire_tile.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/shared/loading.dart';

class HireableUser extends StatefulWidget{

  List<UserData> userList;
  HireableUser({this.userList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HireableUserState();
  }

}

class _HireableUserState extends State<HireableUser>{

  @override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.userList.length == 0){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Text("aucun utilisateur trouvé",style: TextStyle(color: Colors.black87,fontSize: 20),),
      );
    }
    else {

      return ListView.builder(
        itemCount: widget.userList.length,
        itemBuilder: (context, index) {
          return ItemSearchTile(userData: widget.userList[index]);
        },
      );
    }
  }

}