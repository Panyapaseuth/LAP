import 'package:LAP/screen/register/register_page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'register_page3.dart';

class RegisterPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage1State();
  }
}

class _RegisterPage1State extends State<RegisterPage1> {
  TextEditingController phoneNumber = TextEditingController();
  final regexpPhoneNum = RegExp(r'^[0-9]*$');

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );


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
            'Phone number',
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
                      _TF("Phone number", TextInputType.number, phoneNumber),
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
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) =>
              //       RegisterPage2(phoneNumber.text),
              // ));

              if (phoneNumber.text.isEmpty) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Phone Number to the Text"));
              }
              else if (regexpPhoneNum.hasMatch(phoneNumber.text) == false) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Format Error",
                        "Please Input Number only to the text"));
              }
              else if (phoneNumber.text.length < 8) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Error",
                        "Please Input Number 8 digits to the text"));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  // builder: (context) => RegisterPage2(phoneNumber.text),
                  builder: (context) => RegisterPage3(phoneNumber.text),
                ));
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
