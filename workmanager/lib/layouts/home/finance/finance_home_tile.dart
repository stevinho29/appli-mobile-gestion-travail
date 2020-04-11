import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/finance/payment/main_payment.dart';
import 'package:work_manager/layouts/home/finance/payment/payment_form.dart';
import 'package:work_manager/models/contract.dart';




class FinanceHomeTile extends StatefulWidget{

  Contract contractData;
  FinanceHomeTile({this.contractData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FinanceHomeTileState();
  }

}
class _FinanceHomeTileState extends State<FinanceHomeTile>{

  bool selected= false;


  @override
  void initState() {
  super.initState();
  initializeDateFormatting('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    final paymentList = Provider.of<List<Payment>>(context) ?? [];

    // TODO: implement build

  //  controle la provenance de la proposition
      return Container(
          child: Column(
            children: <Widget>[
              Card(
                child:
                  Row(
                    children: <Widget>[
                      SizedBox(width: 28,),
                      Text(" ${widget.contractData.libelle}",style: TextStyle(fontSize: 20),),
                    ],
                  ),
              ),
              Card(
                child: Container(
                    width: 400,

                  child: Column(
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                             Text("Période actuelle:   début le  "),
                              Text(widget.contractData.cursorPayment == 0 ? DateFormat.yMd('fr-FR').format(widget.contractData.startDate):
                              DateFormat.yMd('fr-FR').format(paymentList[widget.contractData.cursorPayment -1].endDate),style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(width: 15,),
                              Icon(Icons.payment,color: Colors.cyan[100],),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.0,
                        color: Colors.cyan[100],
                      ),
                      GestureDetector(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(child: Text("Payer",style: TextStyle(fontWeight: FontWeight.bold),)),
                                  SizedBox(width: 15,),
                                  RaisedButton(
                                    color: Colors.cyan[100],
                                    child: Icon(Icons.call_to_action,color: Colors.white,),
                                    onPressed: () async {
                                      await showDialog(context: context,
                                      child:AlertDialog(
                                          content:  PaymentForm(contractData: widget.contractData,paymentList: paymentList,),

                                        ));
                                    },
                                  ),
                                ],

                              ),
                            ),
                          ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.0,
                        color: Colors.cyan[100],
                      ),
                      Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Text("Historique",style: TextStyle(fontWeight: FontWeight.bold),)),
                                SizedBox(width: 50,),
                                RaisedButton(
                                  color: Colors.cyan[100],
                                    child: Icon(Icons.history,color: Colors.white,),
                                  onPressed: (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PaymentOverview(paymentList: paymentList,)),
                                    );
                                  },
                                ),
                              ],
                        ),
                      ),
                    ],
                  ),

                ),
              ),
              SizedBox(height: 5,),
            ],
          ),

      );

  }

}

