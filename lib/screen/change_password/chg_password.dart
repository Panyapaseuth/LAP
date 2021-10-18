import 'dart:collection';
import 'dart:convert';

import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passWord = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController userName = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Change Your Password',
            style: TextStyle(),
          ),
          backgroundColor: Color.fromRGBO(13, 68, 148, 1),
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      // _TF("User Name", TextInputType.text, userName),
                      _PW("Old Password", TextInputType.text, oldPassword),
                      _PW("New Password", TextInputType.text, passWord),
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

/*  Widget _TF(String _hintText, TextInputType _keyboardType,
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
  }*/

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
              changePassword(userName.text, oldPassword.text, passWord.text, confirmPassword.text);
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

  Future<String> changePassword(String user, String oldPass, String newPass, String conPass) async {

    Response response;
    String url = ROOT_URL + "/account/changePassword";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["old_password"] = oldPass;
    jsonMap["new_password"] = newPass;
    jsonMap["confirm_password"] = conPass;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await put(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print('Success');
      showDialog(
          context: context,
          builder: (_) => alertDialog("Your Password",
              "Success to Changed"));
      return response.body;
    } else {
      print(response.body);
      showDialog(
          context: context,
          builder: (_) => alertDialog("Your Password",
              "Error or Can't changed"));
      return statusCode.toString();
    }
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
