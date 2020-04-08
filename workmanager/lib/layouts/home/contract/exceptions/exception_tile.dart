import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'exception_setting.dart';





class ExceptionTile extends StatefulWidget{

  Contract contract;
  final Exceptions exceptionData;
  ExceptionTile({this.contract,this.exceptionData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExceptionTileState();
  }

}
class _ExceptionTileState extends State<ExceptionTile> {

  bool selected = true;


  @override
  void initState() {
  super.initState();
  initializeDateFormatting('fr-FR');
  }

  @override
    Widget build(BuildContext context) {
      final user = Provider.of<User>(context);

      void _showSettingsPanel(Exceptions exception) {
        showModalBottomSheet(context: context, builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            child: ExceptionSetting(exceptionData: exception),
          );
        });
      }

      // TODO: implement build

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
                      subtitle: Text(" ${widget.exceptionData.price
                          .toString()} € / heure"),
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
                    Visibility(
                      visible: !selected,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Text("début: ${DateFormat.yMd('fr-FR').format(widget.exceptionData.startDate)}       "
                                  " fin: ${DateFormat.yMd('fr-FR').format(widget.exceptionData.endDate)} "),
                           ]),
                          SizedBox(height: 15,),
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
                                      Text("supprimer",
                                          style: TextStyle(
                                              color: Colors.black87)),
                                      SizedBox(width: 5,),
                                      Icon(Icons.clear,
                                        color: Colors.red,)
                                    ]),
                                  ),
                                  onPressed: () async {
                                    if (widget.exceptionData.startDate
                                        .difference(DateTime.now())
                                        .inMicroseconds > 0) {
                                      await ContractDao()
                                          .deleteContractException(
                                          widget.exceptionData)
                                          .then((value) {
                                        Alert().goodAlert(
                                            context, "exception supprimée",
                                            "votre congé pour ${widget
                                                .exceptionData
                                                .motif} a bien été supprimé");
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      Alert().badAlert(
                                          context, "Suppression impossible",
                                          "exception deja prise en compte \n vous ne pouvez plus la supprimer");
                                    }
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
                                      Text("modifer",
                                          style: TextStyle(
                                              color: Colors.black87)),
                                      SizedBox(width: 5,),
                                      Icon(Icons.update,
                                          color: Colors.black87)
                                    ]),
                                  ),
                                  onPressed: () async {
                                    if (widget.contract.employerId !=
                                        user.uid) {
                                      if (widget.exceptionData.startDate
                                          .difference(DateTime.now())
                                          .inMicroseconds > 0) {
                                        _showSettingsPanel(
                                            widget.exceptionData);
                                      }
                                    } else {
                                      Alert().badAlert(
                                          context, "Modification non autorisée",
                                          "Seul l'employeur peut modifier les termes de l'exception");
                                    }
                                  },
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
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
