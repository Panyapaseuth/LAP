import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'electricity_payment_succeeded.dart';


class ElectricityPaymentConfirm extends StatelessWidget {
  final msg;

  const ElectricityPaymentConfirm({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String amount = ModalRoute.of(context).settings.arguments;



    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Confirmation',
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
                      'Electricity Code : ', '000000001',false,false ),
                  _buildWidget('Name : ', 'Thipphasone', false,false),
                  _buildWidget('Bill For : ', '09/2020', false,false),
                  _buildWidget(
                      'Province : ', 'Vientiane Capital', false,false),
                  _buildWidget(
                      'Pending Amount : ', '100,000 LAK', true,false),
                  _buildWidget(
                      'Amount : ',  amount, false,true),
                ],
              ),
            ),

         Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ElectricityPaymentSucceeded(),
                            settings: RouteSettings(
                              arguments: amount,
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
                            "Pay",
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
    String title, String value,bool isAmountPending,bool isAmount) {
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
            color: isAmountPending ? Colors.redAccent:isAmount ? Colors.blue:Colors.black87,
            fontFamily: 'OpenSans',
            fontSize: isAmount ? 24:16,
            fontWeight:  isAmountPending ? FontWeight.w500:isAmount ? FontWeight.w500:FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
