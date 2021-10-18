import 'dart:collection';
import 'dart:developer';
import 'package:LAP/middle_widget/AlertDialog.dart';
import 'package:LAP/screen/transfer/transfer_amount.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:LAP/utilities/cons.dart';
import 'package:http/http.dart';
import 'package:LAP/utilities/function.dart';

class VerifyQuestions extends StatefulWidget {
  final String accID;
  final String accName;

  VerifyQuestions(this.accID, this.accName);

  @override
  _VerifyQuestionsState createState() => _VerifyQuestionsState();
}

class _VerifyQuestionsState extends State<VerifyQuestions> {
  int i = 0;
  List recentQuestion;
  bool isLoading = false;

  TextEditingController answer1 = TextEditingController();
  TextEditingController answer2 = TextEditingController();
  TextEditingController answer3 = TextEditingController();

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
          'Secret Questions',
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(children: <Widget>[
            item(0, answer1, context),
            item(1, answer2, context),
            item(2, answer3, context),

          ])),
          _Button(),
        ],
      ),
    );
  }

  Future<bool> verifySecretQuestion() async {
    Response response;
    String url = ROOT_URL + "/secretQuestion/verifyAnswer";
    Map<String, String> headers = {"Content-type": "application/json"};
    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    List<LinkedHashMap<String, dynamic>> details =
        <LinkedHashMap<String, dynamic>>[];
    LinkedHashMap<String, dynamic> detail = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    detail["question_id"] = recentQuestion[0]["id"];
    detail["answer"] = answer1.text;
    details.add(detail);
    detail["question_id"] = recentQuestion[1]["id"];
    detail["answer"] = answer2.text;
    details.add(detail);
    detail["question_id"] = recentQuestion[2]["id"];
    detail["answer"] = answer3.text;
    details.add(detail);
    jsonMap["details"] = details;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print(response.body);
      var responseObj = jsonDecode(response.body);
      if (responseObj["status"] == "ACCEPT") {
       return true;
      } else{
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> addReceiverAccount(
      String receiverAccId, String receiverAccountName) async {
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
      return true;

    } else {
      return false;
    }
  }

  Widget _Button() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50.0,
          child: RaisedButton(
            onPressed: () {
              setState(() async {
                bool verifyQuestion= await  verifySecretQuestion();
                if(verifyQuestion){
                  bool  addedAccount=await addReceiverAccount(widget.accID, widget.accName);
                  if (addedAccount){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          TransferAmount(widget.accID, widget.accName, null),
                    ));
                  }
                }else{
                  showWarningDialog(context, "Incorrect answer", "Your answer was incorrect at least one question\nPlease try again");
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
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  fetchRecent() async {
    var url = ROOT_URL +
        '/secretQuestion/secretQuestionList/' +
        accountInfo["account_id"].toString();
    log(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        recentQuestion = items;
        isLoading = false;
      });
    } else {
      recentQuestion = null;
      isLoading = false;
    }
  }

  Widget item(int i, TextEditingController _controller, BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recentQuestion == null
                  ? "*"
                  : "* "+recentQuestion[i]["question"].toString(),
              style: TextStyle(color: Color.fromRGBO(91, 93, 94, 1),fontSize: 17,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Answer",
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
}
