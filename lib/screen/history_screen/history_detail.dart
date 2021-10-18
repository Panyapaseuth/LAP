import 'dart:convert';
import 'package:LAP/models/Transaction.dart';
import 'package:LAP/utilities/FadeAnimation.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryDetail extends StatefulWidget {
  final String ref;
  final String title;

  HistoryDetail(this.ref, this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryDetailState();
  }
}

class _HistoryDetailState extends State<HistoryDetail> {
  Future<Transaction> getTrxDetail(String ref) async {
    var url = ROOT_URL + "/transaction/detail/" + ref;
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      return Transaction.fromJson(
          jsonDecode(Utf8Decoder().convert(response.bodyBytes)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: FutureBuilder(
        future: getTrxDetail(widget.ref),
        builder: (BuildContext context, AsyncSnapshot<Transaction> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return Center(child: Text("Null"));
            } else {
              return _trxDetail(context, snapshot.data);
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Center(child: Text("Sorry, some thing wrong"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

Widget _trxDetail(BuildContext context, Transaction _trxDetail) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      child: Stack(
          fit: StackFit.expand,
          children: [
        Column(children: [
            _trxDetail.income
                ? FadeAnimation(
                    .2,
                    _buildWidget(
                        AppLocalizations.of(context).fromAccount,
                        _trxDetail.toOrFromName,
                        _trxDetail.toOrFromAcc.toString().padLeft(16, "0"),
                        context))
                : FadeAnimation(
                    .2,
                    _buildWidget(
                        AppLocalizations.of(context).fromAccount,
                        accountInfo["account_name"].toString(),
                        accountInfo["account_id"].toString().padLeft(16, '0'),
                        context)),
            SizedBox(
              height: 5,
            ),
            _trxDetail.income
                ? FadeAnimation(
                    .4,
                    _buildWidget(
                        AppLocalizations.of(context).toAccount,
                        accountInfo["account_name"].toString(),
                        accountInfo["account_id"].toString().padLeft(16, '0'),
                        context))
                : FadeAnimation(
                    .4,
                    _buildWidget(
                        AppLocalizations.of(context).toAccount,
                        _trxDetail.toOrFromName,
                        _trxDetail.toOrFromAcc.toString().padLeft(16, "0"),
                        context)),
            SizedBox(
              height: 5,
            ),
            FadeAnimation(
                .6,
                Column(children: [
                  _amount(context,_trxDetail),
                  _Date(context,_trxDetail.date),
                  _ReferenceNumber(context,_trxDetail.tranxId.toUpperCase()),
                  _desc(context, _trxDetail.description.toString()),
                ])),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            ),
          ]),

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
              data: _trxDetail.tranxId.toUpperCase(),
              version: QrVersions.auto,
              size: 100.0,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(35, 35),
              ),
            ),
          ),
        ),
      ]),
    ),
  );
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
                        overflow: TextOverflow.ellipsis,
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

Widget _amount(BuildContext context,Transaction trax) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(217, 217, 218, .55),
          offset: Offset(0, 0),
          blurRadius: 2,
          spreadRadius: 1,
        )
      ],
      color: Colors.white,
    ),
   // height: 70,
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
                  AppLocalizations.of(context).amount,
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'OpenSans',
                    fontSize: 12.0,
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
                  trax.income
                      ? "+" + formatDecimal(trax.credit) + " LAK"
                      : "-" + formatDecimal(trax.debit) + " LAK",
                  style: TextStyle(
                    color: trax.income
                        ? Color.fromRGBO(1, 216, 87, 1)
                        : Colors.redAccent,
                    fontFamily: 'OpenSans',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

Widget _ReferenceNumber(BuildContext context,String ref) {
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
    //height: 60,
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
                  AppLocalizations.of(context).ref,
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'OpenSans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 25),
                Container(
                  width: MediaQuery.of(context).size.width -50,
                  child: Text(
                    ref,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

Widget _Date(BuildContext context,String date) {
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
    //height: 60,
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
                  AppLocalizations.of(context).date,
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'OpenSans',
                    fontSize: 12.0,
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
                  date, //formatDecimal(int.parse(amount)) + " LAK",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}

Widget _desc(BuildContext context, String desc) {
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
                  AppLocalizations.of(context).desc,
                  style: TextStyle(
                    color: Colors.black38,
                    fontFamily: 'OpenSans',
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 25),
                Container(
                  width: c_width(context),
                  child: Text(
                    desc,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
