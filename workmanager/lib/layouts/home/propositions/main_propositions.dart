import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_manager/layouts/home/propositions/propositions_list.dart';
import 'package:work_manager/models/proposition.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/propositionDao.dart';


class PropositionsOverview extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PropositionsOverviewState();
  }

}

class _PropositionsOverviewState extends State<PropositionsOverview>{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    // TODO: implement build
    return StreamBuilder<List<Proposition>>(
        stream: PropositionDao(uid: user.uid).getPropositions,
        builder: (context, snapshot) {
          List<Proposition> list= snapshot.data;
          if (snapshot.hasData) {
            print("dans MAIN PROPOSITION  ${list[0].dat['endDate']}");
            return  PropositionList(propositionList: list);
          }else
            return Container(
              child: Text("NO PROPOSITIONS SO FAR"),
            );
        }
    );
  }

}