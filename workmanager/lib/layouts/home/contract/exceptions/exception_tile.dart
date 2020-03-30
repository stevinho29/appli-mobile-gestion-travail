import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_manager/layouts/home/contract/show_contract.dart';
import 'package:work_manager/models/contract.dart';

import 'package:work_manager/models/user.dart';



class ExceptionTile extends StatefulWidget{

  final Exceptions exceptionData;
  ExceptionTile({this.exceptionData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExceptionTileState();
  }

}
class _ExceptionTileState extends State<ExceptionTile>{

  bool selected= false;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final user = Provider.of<User>(context);

      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {

              },
              child: Container(
                height: selected ? 75.0 : 175.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.exceptionData.motif),
                      subtitle: Text(" ${widget.exceptionData.price.toString()} € / heure" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 2,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.exceptionData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .exceptionData.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 80),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("supprimer",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.clear,
                                  color: Colors.red,)
                              ]),
                            ),
                            onPressed: () {

                            },
                          ),
                        ),

                      ],
                    ),
                  ],
                ),

              ),
            ),
          ),
        ),
        onTap: () {
          /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropositionMaker(choosedUser: userData)),
        );*/
        },
      );
  }

}

