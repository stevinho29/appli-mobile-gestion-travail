import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';


class PaymentTile extends StatefulWidget{

  final Payment paymentData;
  PaymentTile({this.paymentData});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentTileState();
  }

}
class _PaymentTileState extends State<PaymentTile>{

  bool selected= false;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    final user = Provider.of<User>(context);
 //  controle la provenance de la proposition
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {

              },
              child: Container(
                height: selected ? 75.0 : 175.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.paymentData.documentId),
                      subtitle: Text(" ${widget.paymentData.finalSalary.toString()} € / heure" ),
                      trailing: GestureDetector(
                        child: Icon(Icons.expand_more),
                        onTap: () {
                          setState(() {
                            selected = !selected;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),

                      ],
                    ),
                    SizedBox(height: 2,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("début: ${widget.paymentData.startDate
                            .toString()
                            .split(" ")[0]}        fin: ${widget
                            .paymentData.endDate.toString().split(
                            " ")[0]}"),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 85),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("consulter",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.collections,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () {
                             /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContractHome(contract: widget.contractData,)),
                              );*/
                            },
                          ),
                        ),


                      ],
                    ),
                  ],
                ),

              ),
            ),
          ),
        ),
        onTap: () {
        },
      );

  }

}

