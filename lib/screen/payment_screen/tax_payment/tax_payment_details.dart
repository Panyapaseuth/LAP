import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaxPaymentDetails extends StatelessWidget {
  final msg;

  const TaxPaymentDetails({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amount = ModalRoute.of(context).settings.arguments;
    TextEditingController amountController = TextEditingController()..text = amount;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tax Payment Details',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildWidget('From account(LAK)', 'THIPPHASONE XOUMSONG',
                'XXXX-XXXX-XXXX-XXXX', context),
            _buildWidget('To account(LAK)', 'ທິບພະສອນ XOUMSONG',
                'XXXX-XXXX-XXXX-XXXX', context),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextField(
                      controller: amountController,
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
                      onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

Widget _buildWidget(String fromOrTo, String accountName, String accountID,
    BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(217, 217, 218, .4),
          offset: Offset(0, 0),
          blurRadius: 0,
          spreadRadius: 0.5,
        )
      ],
      color: Colors.white,
    ),
    height: 120,
    child: InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20),
          Icon(
            Icons.account_circle,
            color: Color.fromRGBO(13, 68, 148, .9),
            size: 60.0,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fromOrTo,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'OpenSans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                accountName,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 5),
              Text(
                accountID,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
