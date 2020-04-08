import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'exceptions_list.dart';


class ExceptionsOverview extends StatefulWidget{

  Contract contract;
  ExceptionsOverview({this.contract});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExceptionsOverviewState();
  }

}

class _ExceptionsOverviewState extends State<ExceptionsOverview>{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    // TODO: implement build
    return StreamBuilder<List<Exceptions>>(
        stream: ContractDao(uid: user.uid).getContractExceptions(widget.contract),
        builder: (context, snapshot) {
          List list= snapshot.data;
          print("LISTE DES Exceptions $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            return  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Exceptions "),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ExceptionList(contract: widget.contract,exceptionList: list))
            );
          }else
            return Scaffold(
                body:Container(
                  child: Center(child: Text("AUCUNE EXCEPTION DECLAREE ")),
                )
            );
        }
    );
  }

}