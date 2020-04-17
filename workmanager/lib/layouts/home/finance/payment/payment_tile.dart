import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_manager/layouts/home/finance/payment/show_payment.dart';
import 'package:work_manager/models/contract.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import 'package:work_manager/shared/constantPaths.dart';


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
  void initState() {
  super.initState();
  initializeDateFormatting('fr-FR');

  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    //final user = Provider.of<User>(context);
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
                      title: Text("ID: ${widget.paymentData.documentId}"),
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
                        SizedBox(width: 25,),
                        Text("Début: "),
                        Text("${DateFormat.yMd('fr-FR').format(widget.paymentData.startDate)}",style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 15,),
                        Text("Fin: "),
                        Text("${DateFormat.yMd('fr-FR').format(widget.paymentData.endDate)}",style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ShowPayment(payment: widget.paymentData,)),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Row(children: <Widget>[
                                Text("exporter",
                                    style: TextStyle(color: Colors.black87)),
                                SizedBox(width: 5,),
                                Icon(Icons.file_download,
                                  color: Colors.black87,)
                              ]),
                            ),
                            onPressed: () async {
                              final pdf = pw.Document();

                              pdf.addPage(pw.Page(pageFormat: PdfPageFormat.a4,
                              build: (context){
                                return pw.Center(
                                child: pw.Text("PDF AWESOME")
                                );
                              }));
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContractHome(contract: widget.contractData,)),
                              );*/
                              
                              Permission permission= Permission.storage;
                              await permission.request().then((value) async {
                                if(value== PermissionStatus.granted){
                                  print(value);
                                  try {

                                    final output = await getExternalStorageDirectory(); // use the [path_provider (https://pub.dartlang.org/packages/path_provider) library:
                                    print(output);
                                    //File("workmanager/example.pdf").create().then((value) async {
                                    File file= File("${output.path}/example.pdf");
                                    await file.writeAsBytes(pdf.save()).then((value){
                                      print(value);
                                    });
                                  }catch(e){
                                    print(e);
                                    print("failure occured when accessing external storage");
                                  }
                                }
                                else{
                                  print(value);
                                }
                              });

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

