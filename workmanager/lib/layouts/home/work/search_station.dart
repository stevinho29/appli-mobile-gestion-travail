
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/work/user_to_hire_list.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/userDao.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:work_manager/shared/loading.dart';


class SearchStation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchStationState();
  }

}

class _SearchStationState extends State<SearchStation>{

  static List<UserData> list;
  static String _name= "";

  bool isBlank = true;
  bool loading = false;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
            child: Form(
              child: TextFormField(
                controller: myController,
                decoration: textInputDecoration.copyWith(
                    hintText: "type someone").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.black,),
                    onPressed: () {
                      print("je teste ${myController.text}");
                      setState(() {
                        loading= !loading;
                        _name = myController.text;
                      });

                      UserDao(user.uid).specificHireableUser(_name).then((value) {
                        setState(() {
                          print("VALEUR DE LA LISTE $value");
                          
                          list = UserDao(user.uid).hireableUserFromQshot(value);
                          isBlank=false;
                          loading = !loading;
                        });
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          isBlank ? Blank(): Expanded(
            child: HireableUser(userList: list),
          )
        ],
      ),
    );
  }

}
