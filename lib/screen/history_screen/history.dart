import 'dart:convert';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'history_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class History extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryState();
  }
}

class _HistoryState extends State<History> {
  List transactions = [];
  bool isLoading = false;
  List myList;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHistory();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).history,
            style: TextStyle(),
          ),
          backgroundColor: Color.fromRGBO(13, 68, 148, 1),
        ),
        body: getBody()
    );
  }

  fetchHistory() async {
    setState(() {
      isLoading = true;
    });
    var url = ROOT_URL + "/transaction/list/" +
        accountInfo["account_id"].toString();
    var response = await http.get(url);

    if (response.statusCode == 200) {

      var items = json.decode( Utf8Decoder().convert(response.bodyBytes));
      setState(() {
        transactions = items;
        isLoading = false;
      });
    } else {
      transactions = [];
      isLoading = false;
    }
  }

  Widget getBody() {
    if (transactions.contains(null) || transactions.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: transactions.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == transactions.length) {
            // return CupertinoActivityIndicator();
            return Container();
          }
          //return ListTile(title: Text(myList[index]));
          return historyItem(transactions[index]);
        });
  }

//bool income,IconData icon, String title, String accountID, String des,    String amount, BuildContext context
  Widget historyItem(item) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 2.5, top: 2.5, left: 5.0, right: 5.0),
      child: Container(
        padding: const EdgeInsets.only(
            bottom: 5, top: 5),
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

        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 15),
              _buildIcon(item["tranx_type_en"], item["income"]),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width  - 250.0,
                            child: Text(

                              (item["tranx_type_en"] == "credit trasfer")
                                  ? item["income"] ? item["tranx_type_en"]
                                  .toString()
                                  .inCaps + " received" : item["tranx_type_en"]
                                  .toString()
                                  .inCaps + " sent":item["tranx_type_en"]
                                  .toString()
                                  .inCaps,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'NotoSansLao',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 150,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                item["income"]
                                    ? "+" + formatDecimal(item["credit"]) + " "+AppLocalizations.of(context).kip
                                    : "-" + formatDecimal(item["debit"]) + " "+AppLocalizations.of(context).kip,
                                style: TextStyle(
                                    color: item["income"]
                                        ? Color.fromRGBO(1, 216, 87, 1)
                                        : Colors.redAccent,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                        ]),
                    SizedBox(height: 5),
                    Row(children: [
                      SizedBox(width: 5),
                      Text(
                        item["income"]
                            ? AppLocalizations.of(context).from+" : " +
                            item["to_or_from_name"].toString().toUpperCase()
                            : AppLocalizations.of(context).to+" : " +
                            item["to_or_from_name"].toString().toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NotoSansLao',
                          fontSize: 13.0,
                        ),
                      ),
                    ]),
                    SizedBox(height: 2),
                    Row(children: [
                      SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context).date+" : " + item["date"],
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NotoSansLao',
                          fontSize: 13.0,
                        ),
                      )
                    ]),
                    SizedBox(height: 2),
                    Row(children: [
                      SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context).desc +" : " + item["description"],
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'OpenSans',
                          fontSize: 13.0,
                        ),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.push(context, PageTransition(
              type: PageTransitionType.rightToLeft,
              child: HistoryDetail(item["tranx_id"].toString(),(item["tranx_type_en"] == "credit trasfer")
                  ? item["income"] ? item["tranx_type_en"]
                  .toString()
                  .inCaps + " received" : item["tranx_type_en"]
                  .toString()
                  .inCaps + " sent":item["tranx_type_en"]
                  .toString()
                  .inCaps),
            ));
          },
        ),
      ),
    );
  }
}

Widget _buildIcon(String type, bool income) {
  if (type == "credit trasfer") {
    return Container(
      child: new Image.asset(
        income
            ? "assets/icons/income.png"
            : "assets/icons/outcome.png"
        ,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
  } else if (type == "payment") {
    return Container(
      child: new Image.asset(
        income
            ? "assets/icons/payment-01.png"
            : "assets/icons/payment-01.png"
        ,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
  }
}
