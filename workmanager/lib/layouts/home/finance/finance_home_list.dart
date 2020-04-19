import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/finance/finance_home_tile.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/shared/loading.dart';


class FinanceHomeList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _FinanceHomeListState();
  }
}

class _FinanceHomeListState extends State<FinanceHomeList>{

  List<Contract> contracts= [];
  bool loading= true;
  @override
  void dispose() {
    super.dispose();
    Loading();
  }
  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contracts= Provider.of<List<Contract>>(context) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if(contracts.length == 0){
     return Scaffold(
          body: Center(child: Text('Aucun contrat pour le moment'),),
        );
    }
    else {
      return ListView.builder(
        itemCount: contracts?.length,
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
    await Future.delayed(Duration(seconds: 2));
}
}