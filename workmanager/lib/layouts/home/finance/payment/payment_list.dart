import 'package:flutter/material.dart';
import 'package:work_manager/layouts/home/finance/payment/payment_tile.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/shared/loading.dart';

class PaymentList extends StatefulWidget{

  List<Payment> paymentList;
  PaymentList({this.paymentList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentListState();
  }

}

class _PaymentListState extends State<PaymentList>{

bool loading= true;

@override
void dispose() {
super.dispose();
Loading();
}


@override
void initState() {
super.initState();
_delayUntilStop().then((value) {
  setState(() {
    loading= false;
  });
});
}

@override
  Widget build(BuildContext context) {


    // TODO: implement build

    if(widget.paymentList.length == 0) {
      return loading ? Loading():Scaffold(
        body: Container(
          padding: EdgeInsets.all(60),
          child: Text("aucun paiement pour le moment",
            style: TextStyle(color: Colors.black87, fontSize: 20),),
        ),
      );
    }
    else {
      return ListView.builder(
        itemCount: widget.paymentList.length,
        itemBuilder: (context, index) {
          return PaymentTile(paymentData: widget.paymentList[index]);
        },
      );
    }
  }
  Future _delayUntilStop() async{
    await Future.delayed(Duration(seconds: 2));
  }
}