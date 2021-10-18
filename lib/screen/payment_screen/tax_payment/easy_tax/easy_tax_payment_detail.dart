import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'easy_tax_payment_confirm.dart';

class EasyTaxPaymentDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _amountController = TextEditingController();
    final String amount = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Easy Tax Payment Detail',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildWidget(
                      'Electricity Code : ', '000000001',false ),
                  _buildWidget('Name : ', 'Thipphasone', false),
                  _buildWidget('Bill For : ', '09/2020', false),
                  _buildWidget(
                      'Province : ', 'Vientiane Capital', false),
                  _buildWidget(
                      'Pending Amount : ', amount , true),
                ],
              ),
            ),

            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black26, width: .5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EasyTaxPaymentConfirm(),
                            settings: RouteSettings(
                              arguments: _amountController.text,
                            )
                        ));
                      },

                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(13, 68, 148, .9),
                              Color.fromRGBO(52, 123, 223, 1),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Next",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }
}

Widget _buildWidget(
    String title, String value,bool isAmountPending) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(217, 217, 218, .4),
          offset: Offset(0, 0),
          blurRadius: .5,
          spreadRadius: 0.2,
        )
      ],
      color: Colors.white,
    ),
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        Text(
          title,
          style: TextStyle(
            color: Colors.black45,
            fontFamily: 'OpenSans',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 20),
        Text(
          value,
          style: TextStyle(
            color: isAmountPending ? Colors.redAccent:Colors.black87,
            fontFamily: 'OpenSans',
            fontSize: isAmountPending ? 22:16,
            fontWeight:  isAmountPending ? FontWeight.w500:FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
