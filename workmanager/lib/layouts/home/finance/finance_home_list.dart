import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/finance/finance_home_tile.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/shared/loading.dart';


class FinanceHomeList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FinanceHomeListState();
  }
}

class _FinanceHomeListState extends State<FinanceHomeList>{


  @override
  Widget build(BuildContext context) {

    final contracts= Provider.of<List<Contract>>(context) ?? [];

    // TODO: implement build

    if(contracts.length == 0){
      _delayUntilStop().then((value) {
        return Scaffold(
          body: Center(child: Text('Aucun contrat pourr le moment'),),
        );
      });
      return Loading();

    }
    else {

      return ListView.builder(
        itemCount: contracts.length,
        itemBuilder: (context, index) {
          return StreamProvider<List<Payment>>.value(
            value: ContractDao().getPayments(contracts[index]),
            child: FinanceHomeTile(contractData: contracts[index])

          );
        },
      );
    }
  }

  Future _delayUntilStop() async{
    await Future.delayed(Duration(seconds: 5));
}
}