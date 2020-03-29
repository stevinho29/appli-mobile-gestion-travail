import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/layouts/home/work/user_to_hire_list.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/databases/userDao.dart';
import 'package:workmanager/shared/constants.dart';
import 'package:workmanager/shared/loading.dart';


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

  List<UserData> _mapping(QuerySnapshot snapshot){
   return snapshot.documents.map((doc) {
      print(doc.data['name']);
      return UserData(
          uid: doc.data['uid'] ?? 'no uid',
          name: doc.data['name'] ?? 'no name',
          surname: doc.data['surname'] ?? 'no surname',
          email: doc.data['email'] ?? 'no email',
          rue: doc.data['address']['rue'] ?? 'no address',
          codePostal: doc.data['address']['code_postal'] ?? 'no address',
          tel: doc.data['tel'] ?? 'no tel',
          findable: doc.data['findable'] ?? false,
          createdAt:  DateTime(0000,00,00) // DateTime.fromMillisecondsSinceEpoch(
      );
    }).toList();
  }

  bool isBlank = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final myController = TextEditingController();


    @override
    void dispose() {
      // Clean up the controller when the widget is removed from the
      // widget tree.
      myController.dispose();
      super.dispose();
    }
    // TODO: implement build

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
