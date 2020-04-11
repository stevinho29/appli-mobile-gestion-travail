import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/finance/payment/payment_list.dart';
import 'package:work_manager/models/contract.dart';



class PaymentOverview extends StatefulWidget{

  List<Payment> paymentList;
  PaymentOverview({this.paymentList});

  bool isEmployer;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentsOverviewState();
  }
}

class _PaymentsOverviewState extends State<PaymentOverview>{
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
    //final paymentList = Provider.of<List<Payment>>(context);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Paiements"),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: PaymentList(paymentList: widget.paymentList,))
    );
  }


}