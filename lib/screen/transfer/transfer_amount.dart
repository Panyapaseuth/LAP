import 'dart:convert';

import 'package:LAP/middle_widget/AlertDialog.dart';
import 'package:LAP/models/Account.dart';
import 'package:LAP/screen/transfer/transfer_desc.dart';
import 'package:LAP/utilities/FadeAnimation.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransferAmount extends StatefulWidget {
  final String destinationAccount;
  final String destinationName;
  final String amount;

  TransferAmount(this.destinationAccount, this.destinationName, this.amount);

  factory TransferAmount.fromQR(Account account) =>
      TransferAmount(account.accountId, account.accountName, null);

  factory TransferAmount.fromQRWithAmount(Account account, String amount) =>
      TransferAmount(account.accountId, account.accountName, amount);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TransferAmountState();
  }
}

class _TransferAmountState extends State<TransferAmount> {
  bool isButtonEnabled = false;
  bool isTextReadonly = false;
  TextEditingController amountController = TextEditingController();

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

  void _showDescPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DescTransfer(
          widget.destinationAccount,
          widget.destinationName,
          int.parse(amountController.text.replaceAll(',', ''))),
    ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.amount != null) {
      amountController.text = formatDecimal(int.parse(widget.amount));
      isTextReadonly = true;
    }
    if ((amountController.text.trim() != "")) {
      isButtonEnabled = true;
    } else {
      isButtonEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).amount,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    FadeAnimation(
                        .2,
                        _buildWidget(
                            AppLocalizations.of(context).fromAccount,
                            accountInfo["account_name"].toString(),
                            accountInfo["account_id"]
                                .toString()
                                .padLeft(16, '0'),
                            context)),
                    // Icon(
                    //   Icons.keyboard_arrow_down_rounded,
                    //   color: Color.fromRGBO(13, 68, 148, .7),
                    //   size: 40.0,
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    FadeAnimation(
                        .4,
                        _buildWidget(
                            AppLocalizations.of(context).toAccount,
                            widget.destinationName,
                            widget.destinationAccount
                                .toString()
                                .padLeft(16, '0'),
                            context)),
                  ],
                ),
              )
            ]),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    readOnly: isTextReadonly ? true : false,
                    controller: amountController,
                    onChanged: (val) {
                      isAmountEmpty();
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).amount,
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
                    onPressed: isButtonEnabled
                        ? () {
                            if (int.parse(amountController.text) > 10000000) {
                              showWarningDialog(context, 'ເກີນວົງເງີນ',
                                  'ທ່ານບໍ່ສາມາດໂອນກາຍ 10,000,000 ຕໍ່ທຸລະກຳ');
                              return;
                            }

                            if (isNumericUsing_tryParse(
                                amountController.text)) {
                              _showDescPage();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => alertDialog());
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
                          AppLocalizations.of(context).next,
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
              offset: Offset(0, 10))
        ]),
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
                                offset: Offset(0, 10))
                          ],
                          border: Border.all(width: 1.5, color: Colors.white70),
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
