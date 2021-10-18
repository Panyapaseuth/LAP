import 'dart:convert';
import 'dart:developer';

import 'package:LAP/screen/transfer/transfer_amount.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import 'generateQR.dart';

class CreateCustomQR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateCustomQRState();
  }
}

class _CreateCustomQRState extends State<CreateCustomQR> {
  List recentAccount = [];
  bool isLoading = false;
  TextEditingController amountController = TextEditingController();
  bool isButtonEnabled = false;

  bool isAmountEmpty() {
    setState(() {
      if ((amountController.text != "")) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    alertDialog() {
      return AlertDialog(
        title: Text("Invalid amount"),
        content: Text("Please try to retyping"),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create custom QR',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            autocorrect: true,
            controller: amountController,
            onChanged: (val) {
              isAmountEmpty();
            },
            decoration: InputDecoration(
              hintText: 'Amount',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: isButtonEnabled
                    ? () {
                        if (isNumericUsing_tryParse(amountController.text)) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                GenerateQR(true, amountController.text),
                          ));
                        } else {
                          showDialog(
                              context: context, builder: (_) => alertDialog());
                        }
                        //
                      }
                    : null,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isButtonEnabled
                          ? [
                              Color.fromRGBO(13, 68, 148, .9),
                              Color.fromRGBO(52, 123, 223, 1),
                            ]
                          : [
                              Colors.white70,
                              Colors.white70,
                            ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Create custom QR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
