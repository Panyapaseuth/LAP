import 'dart:collection';
import 'dart:convert';

import 'package:LAP/screen/secret_questions/questions.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../main.dart';
import '../home.dart';

class RegisterPage5 extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String gender;
  final String married;
  final String birthdate;
  final String village;
  final String district;
  final String province;

  RegisterPage5(this.phoneNumber, this.firstName, this.lastName, this.gender,
      this.married, this.birthdate, this.village, this.district, this.province);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage5State();
  }
}

class _RegisterPage5State extends State<RegisterPage5> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController userName = TextEditingController();

  List recentAccount = [];
  bool isLoading = false;

  final regexpUser = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.fetchRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blueGrey, //change your color here
          ),
          title: Text(
            'Your password',
            style: TextStyle(color: Colors.black54),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      _TF("User Name", TextInputType.text, userName),
                      _PW("Password", TextInputType.text, password),
                      _PW("Confirm Password", TextInputType.text,
                          confirmPassword),
                      Expanded(
                        child: Container(),
                      ),
                      _Button(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<String> attemptRegister(
      String acctName,
      String password,
      String userName,
      String amount,
      String firstName,
      String lastName,
      String birthdate,
      String gender,
      String village,
      String phoneNumber,
      String married,
      String district) async {
    Response response;
    //try {
    //final result = await InternetAddress.lookup("http://"+SERVER_IP);
    //  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    // print('connected');
    //try {
    String url = "$ROOT_URL/account/register";
    Map<String, String> headers = {"Content-type": "application/json"};
    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["balance"] = 0;
    jsonMap["user_name"] = phoneNumber;
    jsonMap["password"] = password;
    jsonMap["first_name"] = firstName;
    jsonMap["last_name"] = lastName;
    jsonMap["birth_date"] = birthdate;
    jsonMap["gender"] = gender;
    jsonMap["village"] = village;
    jsonMap["married"] = true;
    jsonMap["phone"] = phoneNumber;
    jsonMap["district"] = district;
    String jsonStr = JsonEncoder().convert(jsonMap);

    response = await post(url, headers: headers, body: jsonStr)
        .timeout(Duration(seconds: timeout));
    // } on TimeoutException catch (e) {
    //   print("timeout");
    //   return "timeout";
    // }
    int statusCode = response.statusCode;
    print("Status : " + statusCode.toString());
    if (statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      print(response.body);

      return statusCode.toString();
    }
    //   }
    // } on SocketException catch (_) {
    //   print('not connected');
    //   return "not connected";
    // }
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
            onPressed: () async {
              if (userName.text.isEmpty) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your User Name to the Text"));
              } else if (regexpUser.hasMatch(userName.text) == false) {
                showDialog(
                    context: context,
                    builder: (_) =>
                        alertDialog("Format Error", "Please check your Email"));
              } else if (password.text.length < 8) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Password more than 8 char"));
              } else if (password.text.isEmpty) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Password to the Text"));
              } else if (confirmPassword.text.isEmpty) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Confirm Password to the Text"));
              } else if (password.text != confirmPassword.text) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Not Matching",
                        "Please check your password and confirm password is not matching"));
              } else {
                // _validate = false;
                String jwt = await attemptRegister(
                    widget.firstName + widget.lastName,
                    password.text,
                    userName.text,
                    /*balance */ "0",
                    widget.firstName,
                    widget.lastName,
                    widget.birthdate,
                    widget.gender,
                    widget.village,
                    widget.phoneNumber,
                    widget.married,
                    widget.district);
                if (jwt == "401") {
                  showDialog(
                      context: context,
                      builder: (_) => alertDialog("Invalid User",
                          "Please check your Email or Password again"));
                } else {
                  storage.write(key: "jwt", value: jwt);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // builder: (context) => Home.fromBase64(jwt)));
                          builder: (context) => SecretQuestions(jwt)));
                }
              }
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
    );
  }

  Widget _TF(String _hintText, TextInputType _keyboardType,
      TextEditingController controller) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hintText,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(
              height: 6,
            ),
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

  Widget _PW(String _hintText, TextInputType _keyboardType,
      TextEditingController controller) {
    return Container(
        padding: EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _hintText,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(
              height: 6,
            ),
            TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: _keyboardType,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
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
}
