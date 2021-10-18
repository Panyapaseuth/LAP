import 'dart:convert';

import 'package:LAP/screen/register/register_page4.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class RegisterPage3 extends StatefulWidget {
  final String phoneNumber;
  RegisterPage3(this.phoneNumber);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage3State();
  }
}

enum Location { livingRoom, bedroom, kitchen, others }
enum Gender { M, F }
enum Married { False, True }

class _RegisterPage3State extends State<RegisterPage3> {
  Location location = Location.livingRoom;
  Gender gender = Gender.M;
  Married married = Married.False;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  /* List<String> gender = ['Male', 'Female'];
  List<String> married = ['False', 'True'];*/

  String actualLocation = 'Living Room';
  String actualGender = "M";
  String actualMarried = 'False';

  int group = 1;

  int selectedGender = 0;

  DateTime date = DateTime.now();

  bool _validate = false;

  Future<Null> birthDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1940),
        lastDate: DateTime.now());

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

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
            'General information',
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
                      _TF("First name", TextInputType.text, firstName),
                      _TF("Last name", TextInputType.text, lastName),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Gender :"),
                              ])),
                      RadioListTile<Gender>(
                        title: const Text('Male'),
                        value: Gender.M,
                        groupValue: gender,
                        onChanged: (Gender value) {
                          setState(() {
                            gender = value;
                            actualGender = 'M';
                          });
                        },
                      ),
                      RadioListTile<Gender>(
                        title: const Text('Female'),
                        value: Gender.F,
                        groupValue: gender,
                        onChanged: (Gender value) {
                          setState(() {
                            gender = value;
                            actualGender = 'F';
                          });
                        },
                      ),

                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Married :"),
                              ])),
                      RadioListTile<Married>(
                        title: const Text('False'),
                        value: Married.False,
                        groupValue: married,
                        onChanged: (Married value) {
                          setState(() {
                            married = value;
                            actualMarried = 'False';
                          });
                        },
                      ),
                      RadioListTile<Married>(
                        title: const Text('True'),
                        value: Married.True,
                        groupValue: married,
                        onChanged: (Married value) {
                          setState(() {
                            married = value;
                            actualMarried = 'True';
                          });
                        },
                      ),

                      /* RadioListTile<Location>(
                        title: const Text('True'),
                        value: Location.bedroom,
                        groupValue: location,
                        onChanged: (Location value) {
                          setState(() {
                            location = value;
                            actualLocation = 'Bedroom';
                          });
                        },
                      ),*/

/*                      SizedBox(
                        height: 10,
                      ),
                      _Choose("Gender :", gender),
                      SizedBox(
                        height: 10,
                      ),
                      _Choose2("Married :", married),*/

                      SizedBox(
                        height: 10,
                      ),
                      _Birthdate(),
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
              //       RegisterPage4(widget.phoneNumber,firstName.text,lastName.text,"",""),
              // ));
              if (firstName.text.isEmpty) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your First Name to the Text"));
              } else if (lastName.text.isEmpty) {
                // _validate = true;
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Last Name to the Text"));
              }
              else {
                // _validate = false;
                /*print(actualGender);
                print(actualMarried.toLowerCase());
                print(date.toString());*/
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterPage4(widget.phoneNumber,
                      firstName.text, lastName.text, actualGender, actualMarried.toLowerCase(), date.toString()),
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

  Widget _Birthdate() {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Birth Date : "),
          SizedBox(
            width: 20,
          ),
          OutlineButton(
            onPressed: () {
              birthDate(context);
            },
            color: Colors.blueAccent,
            textColor: Colors.black54,
            child: Text(date.day.toString() +
                        date.month.toString() +
                        date.year.toString() !=
                    DateTime.now().day.toString() +
                        DateTime.now().month.toString() +
                        DateTime.now().year.toString()
                ? date.day.toString().padLeft(2, '0') +
                    "/" +
                    date.month.toString().padLeft(2, '0') +
                    "/" +
                    date.year.toString()
                : "Select your birth date"),
          ),
        ],
      ),
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

/*  Widget _buildGender(String txt, int index) {
    return FlatButton(
      onPressed: () => changeIndex(index),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: selectedGender == index ? Colors.blueAccent : Colors.white,
      child: Text(
        txt,
        style: TextStyle(
            color: selectedGender == index ? Colors.white : Colors.grey),
      ),
    );
  }

  void changeIndex(int index) {
    setState(() {
      selectedGender = index;
    });
  }*/

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
