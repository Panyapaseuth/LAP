import 'dart:collection';
import 'dart:convert';

import 'package:LAP/utilities/FadeAnimation.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../main.dart';
import '../home.dart';

class TransferSucceeded extends StatefulWidget {
  final String destinationAccount;
  final int amount;
  final String destinationName;
  final String description;

  TransferSucceeded(this.destinationAccount, this.destinationName, this.amount,
      this.description);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TransferSucceededState();
  }
}

class _TransferSucceededState extends State<TransferSucceeded> {
  Future<bool> transfer(String targetAccount, String amount, String trxType,
      String desc) async {
    var jwt = await storage.read(key: "jwt");
    String jwtStr = jwt.split("\"")[3];
    String url = "$ROOT_URL/transaction/creditTransfer";
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Authorization': 'Bearer $jwtStr',
    };
    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["from_account_id"] = accountInfo["account_id"].toString();
    jsonMap["to_account_id"] = targetAccount.toString();
    jsonMap["amount"] = int.parse(amount);
    jsonMap["description"] = desc;
    jsonMap["tranx_type_id"] = int.parse(trxType);
    String jsonStr = JsonEncoder().convert(jsonMap);
    // print(JsonEncoder().convert(jsonMap));
    Response response = await post(url, headers: headers, body: jsonStr)
        .timeout(Duration(seconds: timeout));
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      sendNotification(targetAccount.toString(), "Fund Transfer",
          "$amount LAK Success\n $desc");
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: transfer(widget.destinationAccount.toString(),
          widget.amount.toString(), "1", widget.description.toString()),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            if (snapshot.data) {
              return succeeded(true);
            } else {
              return succeeded(false);
            }
          } else {
            return succeeded(false);
          }
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Center(child: Text("Sorry, some thing wrong"));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations
                      .of(context)
                      .processing,
                  style: TextStyle(),
                ),
                backgroundColor: Color.fromRGBO(13, 68, 148, 1),
              ),
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  Widget succeeded(bool succeeded) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          succeeded
              ? AppLocalizations
              .of(context)
              .transferSucceeded
              : AppLocalizations
              .of(context)
              .transferFailed,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    FadeAnimation(
                      .2,
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            succeeded ? Icons.done : Icons.error_outline,
                            color: succeeded
                                ? Color.fromRGBO(7, 205, 164, .9)
                                : Color.fromRGBO(248, 50, 91, .9),
                            size: 80.0,
                          )),
                    ),
                    Text(
                      succeeded
                          ? AppLocalizations
                          .of(context)
                          .succeeded
                          : AppLocalizations
                          .of(context)
                          .failed,
                      style: TextStyle(
                          fontSize: 20,
                          color: succeeded
                              ? Color.fromRGBO(7, 205, 164, .9)
                              : Color.fromRGBO(248, 50, 91, .9),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildWidget(
                        AppLocalizations
                            .of(context)
                            .fromAccount,
                        accountInfo["account_name"].toString(),
                        accountInfo["account_id"].toString().padLeft(16, '0'),
                        context),
                    SizedBox(
                      height: 5,
                    ),
                    _buildWidget(
                        AppLocalizations
                            .of(context)
                            .toAccount,
                        widget.destinationName,
                        widget.destinationAccount.toString().padLeft(16, '0'),
                        context),
                    SizedBox(
                      height: 5,
                    ),
                    _amount(AppLocalizations
                        .of(context)
                        .amount,
                        widget.amount.toString()),
                    _desc(AppLocalizations
                        .of(context)
                        .description,
                        widget.description),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  formatDate(DateTime.now()),
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'OpenSans',
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            /*Center(
                              child: SizedBox(
                            height: 10,
                          )),*/
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => Home.defaultCon(),
                            ),
                            ModalRoute.withName(""));
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
                            AppLocalizations
                                .of(context)
                                .done,
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

          Positioned(
            right: 20,
            bottom: 70,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10))
                  ]),
              child: QrImage(
                data: "123456789101112ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                version: QrVersions.auto,
                size: 100.0,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(35, 35),
                ),
              ),
            ),
          ),
        ],
      ),
    )
    ;
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 138.0,
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

Widget _amount(String text, String amount) {
  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8),
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
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 25),
                Text(
                  formatDecimal(int.parse(amount)) + " LAK",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'OpenSans',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _desc(String text, String desc) {
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
    // height: 100,
    child: InkWell(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              children: [
                SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 25),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
