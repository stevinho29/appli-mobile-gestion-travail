import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/finance/finance_home_list.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';

class Finance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FinanceState();
  }
}

class _FinanceState extends State<Finance> {
  @override
  Widget build(BuildContext context) {
    final user= Provider.of<User>(context);
    // TODO: implement build
    return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: MultiProvider(
              providers: [
                StreamProvider<List<Contract>>(create: (_) => ContractDao(uid: user.uid).getContracts),
              ],
              child: FinanceHomeList(),
            )
    ));
  }
}
