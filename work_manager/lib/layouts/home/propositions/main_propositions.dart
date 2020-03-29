import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workmanager/layouts/home/propositions/propositions_list.dart';
import 'package:workmanager/models/proposition.dart';
import 'package:workmanager/models/user.dart';
import 'package:workmanager/services/databases/propositionDao.dart';


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
          List list= snapshot.data;
          if (snapshot.hasData) {
            return  PropositionList(propositionList: list);
          }else
            return Container(
              child: Text("NO PROPOSITIONS SO FAR"),
            );
        }
    );
  }

}