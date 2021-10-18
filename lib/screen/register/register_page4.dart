import 'dart:convert';

import 'package:LAP/models/Address.dart';
import 'package:LAP/screen/register/register_page5.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class RegisterPage4 extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String gender;
  final String married;
  final String birthdate;
  RegisterPage4(this.phoneNumber, this.firstName, this.lastName, this.gender,
      this.married, this.birthdate);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage4State();
  }
}

class _RegisterPage4State extends State<RegisterPage4> {
  TextEditingController village = TextEditingController();

  List recentAccount = [];
  bool isLoading = false;

  String selectedProvince;
  List provinceItemList = List();

  String selectedDistrict;
  List districtItemList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getProvince();
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
            'Address',
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
                      Container(
                          padding: EdgeInsets.only(
                              left: 20, top: 15, right: 20, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Province Name: ",
                                style: TextStyle(color: Colors.black87),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                hint: Text("Select Province"),
                                value: selectedProvince,
                                items: provinceItemList?.map((province) {
                                      return DropdownMenuItem(
                                          value: province['id'],
                                          child: Text(province['name_en']));
                                    })?.toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    selectedDistrict = null;
                                    selectedProvince = value;
                                    getDistrict();
                                  });
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: 20, top: 15, right: 20, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "District Name: ",
                                style: TextStyle(color: Colors.black87),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                hint: Text("Select District"),
                                value: selectedDistrict,
                                items: districtItemList?.map((district) {
                                      return DropdownMenuItem(
                                          value: district['id'],
                                          child: Text(district['name_en']));
                                    })?.toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    selectedDistrict = value;
                                  });
                                },
                              ),
                            ],
                          )),
                      _TF("Village Name:", TextInputType.text, village),
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

  Future getProvince() async {
    var url = ROOT_URL + "/address/province";
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {

      var jsonData = json.decode(response.body);
      setState(() {
        provinceItemList = jsonData;
      });
    }
  }

  Future getDistrict() async {
    var url = ROOT_URL +'/address/district/' + selectedProvince;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        districtItemList = jsonData;
      });
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
              if (selectedProvince == null) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog(
                        "Value Empty", "Please Select your Province"));
              } else if (selectedDistrict == null) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your District to the Text"));
              } else if (village.text.isEmpty) {
                showDialog(
                    context: context,
                    builder: (_) => alertDialog("Value Empty",
                        "Please Input your Village to the Text"));
              } else {
                // _validate = false;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterPage5(
                      widget.phoneNumber,
                      widget.firstName,
                      widget.lastName,
                      widget.gender,
                      widget.married,
                      widget.birthdate,
                      village.text,
                      selectedDistrict,
                      selectedProvince),
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
