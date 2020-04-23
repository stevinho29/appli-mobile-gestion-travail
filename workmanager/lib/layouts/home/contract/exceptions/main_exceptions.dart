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
    return FutureBuilder<List<Exceptions>>(
        future: ContractDao(uid: user.uid).getContractExceptionsRightNow(widget.contract),
        builder: (context, snapshot) {
          Widget child;
          List list= snapshot.data;
          print("LISTE DES Exceptions $list");
          if (snapshot.hasData) {
            print("SNAPSHOT $snapshot");
            child=  Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Exceptions "),
                ),
                body: Container(
                    padding: EdgeInsets.all(20),
                    child: ExceptionList(contract: widget.contract,exceptionList: list))
            );
          }else if(snapshot.hasError){
              child= Column(
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ],
              );
          } else {
            child= Column(
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            );
          }
          return child;
        }
    );
  }

}