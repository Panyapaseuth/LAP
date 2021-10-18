import 'dart:collection';
import 'dart:convert';

import 'package:LAP/models/Account.dart';
import 'package:LAP/screen/secret_questions/verify_questions.dart';
import 'package:LAP/screen/transfer/transfer_amount.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../home.dart';

class AccountList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountListState();
  }
}

class _AccountListState extends State<AccountList> {
  List recentAccount = [];
  bool isLoading = false;

  TextEditingController receiverAccountID = TextEditingController();
  // bool _validate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).receiverAccount,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(children: [

        _tF(AppLocalizations.of(context).accountNumber, TextInputType.number, receiverAccountID),
        Text(AppLocalizations.of(context).recentAccount,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black54),),
        Icon(Icons.arrow_drop_down,color: Colors.black54 ),
        Expanded(child: accountList()),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    if (receiverAccountID.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (_) => alertDialog("Value Empty",
                              "Please Input your Account Number to the Text"));
                    } else if(receiverAccountID.text == accountInfo["account_id"]) {
                      showDialog(
                          context: context,
                          builder: (_) => alertDialog("Alert",
                              "Please check your Account Number can't Add"));
                    }
                    else {
                      attemptAddReceiverAccount();
                    }
                  });
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
                      AppLocalizations.of(context).addAccount,
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

  fetchRecent() async {
    setState(() {
      isLoading = true;
    });
    String url = "$ROOT_URL/account/getReceiver/" +
        accountInfo["account_id"].toString().padLeft(16, '0') +
        "/1";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        recentAccount = items;
        isLoading = false;
      });
    } else {
      recentAccount = [];
      isLoading = false;
    }
  }

  Widget accountList() {
    if (recentAccount.contains(null) || recentAccount.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: recentAccount.length,
        itemBuilder: (context, index) {
          return item(recentAccount[index], context);
        });
  }

  alertDialog(String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"))
      ],
    );
  }

  Future<void> attemptAddReceiverAccount() async {
    var url = ROOT_URL +
        '/account/verifyReceiverAccount/' +
        accountInfo["account_id"] +
        '/' +
        receiverAccountID.text +
        '/1';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Success to verify Account");
      Account verifyAccount = Account.fromJson(jsonDecode(response.body));
      // addReceiverAccount(verifyAccount.accountId,verifyAccount.accountName);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            VerifyQuestions(verifyAccount.accountId,verifyAccount.accountName),
      ));
    } else {
      print("Failed to get Account or no have this account");
      showDialog(
          context: context,
          builder: (_) => alertDialog("Add Account Number Failed",
              "Please check your Account Number that you added"));

    }
  }

/*  Future<String> addReceiverAccount(
      String receiverAccId,String receiverAccountName) async {
    Response response;
    String url = ROOT_URL + "/account/addReceiver";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["receiver_type_id"] = 1;
    jsonMap["receiver_account_id"] = receiverAccId;
    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr)
        .timeout(Duration(seconds: timeout));
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TransferAmount(receiverAccId, receiverAccountName, null),
      ));
      return response.body;
    } else {
      print(response.body);
      return statusCode.toString();
    }
  }*/

  Future<String> addRemoveAccount(String receiverAccId) async {
    Response response;
    String url = ROOT_URL + "/account/removeReceiver";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["receiver_account_id"] = receiverAccId;
    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr)
        .timeout(Duration(seconds: timeout));
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      print(response.body);
      return statusCode.toString();
    }
  }

  Widget _tF(String _hintText, TextInputType _keyboardType,
      TextEditingController controller) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: _keyboardType,
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: _hintText,
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
                style: TextStyle(
                  height: 1,
                )),
          ],
        ));
  }

  Widget item(item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 2.5, top: 2.5, left: 5.0, right: 20.0),
      child: Container(
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              Container(
                width: 55,
                height: 55,
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
                    image: NetworkImage("$ROOT_URL/file/image/" +
                        item["account_id"].toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Icon(
              //   Icons.account_circle_rounded,
              //   color: Color.fromRGBO(13, 68, 148, .9),
              //   size: 40.0,
              // ),
              SizedBox(width: 10),
          Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 8,bottom: 8,left:12),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["account_name"].toString().toUpperCase(),
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NotoSansLao',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        item["account_id"].toString().padLeft(16, '0'),
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'NotoSansLao',
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                  ),
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.push(context, PageTransition(
              type: PageTransitionType.rightToLeft,
              child:
                  TransferAmount(item["account_id"], item["account_name"], null),
            ));
          },
          onDoubleTap: () {
            /*showDialog(
                context: context,
                builder: (_) => alertDialog2("Alert",
                    "Do you want to remove this Account ?"));*/

            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("Alert"),
                      content: Text("Do you want to remove this Account ?"),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel")),
                        FlatButton(
                            onPressed: () {
                              addRemoveAccount(item["account_id"]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home.defaultCon()));
                            },
                            child: Text("Sure"))
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
