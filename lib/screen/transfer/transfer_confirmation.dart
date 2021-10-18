import 'dart:convert';
import 'dart:developer';
import 'package:LAP/screen/transfer/transfer_succeeded.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransferConfirmation extends StatefulWidget {
  final String destinationAccount;
  final int amount;
  final String destinationName;
  final String description;
  TransferConfirmation(this.destinationAccount, this.destinationName,this.amount,this.description);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TransferConfirmationState();
  }
}
class _TransferConfirmationState extends State<TransferConfirmation> {



  @override
  Widget build(BuildContext context) {
    final amount = ModalRoute.of(context).settings.arguments;
    TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).transferConfirmation,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
                children: <Widget>[ Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildWidget(
                          AppLocalizations.of(context).fromAccount,
                          accountInfo["account_name"].toString(),
                          accountInfo["account_id"].toString().padLeft(16, '0'),
                          context),
                      // Icon(
                      //   Icons.keyboard_arrow_down_rounded,
                      //   color: Color.fromRGBO(13, 68, 148, .9),
                      //   size: 40.0,
                      // ),
                      SizedBox(height: 5,),
                      _buildWidget(
                          AppLocalizations.of(context).toAccount,
                          widget.destinationName,
                          widget.destinationAccount.toString().padLeft(16, '0'),
                          context),SizedBox(height: 10),Container(
                          child: Text(AppLocalizations.of(context).details)),SizedBox(height: 10),
                      _amount(AppLocalizations.of(context).amount,widget.amount.toString()),_desc(AppLocalizations.of(context).description,widget.description)
                    ],
                  ),
                )]),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () async{
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TransferSucceeded(widget.destinationAccount, widget.destinationName,widget.amount,widget.description),
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
                          AppLocalizations.of(context).transfer,
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
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 20.0,
              offset: Offset(0, 10)
          )
        ]
    ),
    // height: 140,
    child: InkWell(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  fromOrTo,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 75,
                        height: 75,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)
                            )
                          ],
                          border:
                          Border.all(width: 1.5, color: Colors.white70),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                "$ROOT_URL/file/image/" + accountID),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Icon(
                    //   Icons.account_circle,
                    //   color: Color.fromRGBO(13, 68, 148, .9),
                    //   size: 60.0,
                    // ),
                    SizedBox(height: 10),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width  - 138.0,
                      child: Text(
                        accountName.toUpperCase(),
                        style: TextStyle(
                          color: Color.fromRGBO(38, 38, 38, .75),
                          fontFamily: 'OpenSans',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      accountID,
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'OpenSans',
                        fontSize: 17.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _amount(String text,String amount) {
  return Container(
    padding: const EdgeInsets.only(top: 8,bottom: 8),
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

    child: InkWell(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(children: [ SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),],),
            SizedBox(height: 10),
            Row(children: [ SizedBox(width: 25),
              Text(
                formatDecimal(int.parse(amount))+" LAK",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'OpenSans',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),],),
          ],
        ),
      ),
    ),
  );
}

Widget _desc(String text,String desc) {
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
    height: 100,
    child: InkWell(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(children: [ SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),],),
            SizedBox(height: 10),
            Row(children: [ SizedBox(width: 25),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'OpenSans',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),],),
          ],
        ),
      ),
    ),
  );
}