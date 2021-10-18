import 'dart:collection';

import 'package:LAP/middle_widget/AlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:LAP/utilities/cons.dart';
import 'package:http/http.dart';
import 'package:LAP/utilities/function.dart';

import '../home.dart';

class SecretQuestions extends StatefulWidget {
  final String jwt;

  SecretQuestions(this.jwt);

  @override
  _SecretQuestionsState createState() => _SecretQuestionsState();
}

class _SecretQuestionsState extends State<SecretQuestions> {


  TextEditingController answer1 = TextEditingController();
  TextEditingController answer2 = TextEditingController();
  TextEditingController answer3 = TextEditingController();

  final form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    getAccountInfo();
    print(widget.jwt);
    this.getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Secret Questions',
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
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            itemHeight: 80,
                            focusColor: Colors.white,
                            //elevation: 5,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            iconEnabledColor: Colors.black,
                            isExpanded: true,
                            hint: Text(
                              "Select Question",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: selectedQuestion1,
                            items: questionItemList?.map((question) {
                                  return DropdownMenuItem(
                                      value: question['id'],
                                      child: Text(question['question']));
                                })?.toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                selectedQuestion1 = value;
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                      TA('Question 1', 'Please Answer', TextInputType.text, answer1),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            itemHeight: 80,
                            focusColor: Colors.white,
                            //elevation: 5,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            iconEnabledColor: Colors.black,
                            isExpanded: true,
                            hint: Text(
                              "Select Question",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: selectedQuestion2,
                            items: questionItemList?.map((question) {
                                  return DropdownMenuItem(
                                      value: question['id'],
                                      child: Text(question['question']));
                                })?.toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                selectedQuestion2 = value;
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                      TA('Question 2', 'Please Answer',TextInputType.text, answer2),

                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            itemHeight: 80,
                            focusColor: Colors.white,
                            //elevation: 5,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            iconEnabledColor: Colors.black,
                            isExpanded: true,
                            hint: Text(
                              "Select Question",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: selectedQuestion3,
                            items: questionItemList?.map((question) {
                                  return DropdownMenuItem(
                                      value: question['id'],
                                      child: Text(question['question']));
                                })?.toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                selectedQuestion3 = value;
                                print(value);
                              });
                            },
                          ),
                        ),
                      ),
                      TA('Question 3', 'Please Answer',TextInputType.text, answer3),
                      SizedBox(
                        height: 30,
                      ),
                      _Button(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }

  //=============================================================================== Api Calling here

//CALLING STATE API HERE
// Get State information by API
  int selectedQuestion;
  int selectedQuestion1;
  int selectedQuestion2;
  int selectedQuestion3;

  List questionItemList = List();

  Future getQuestions() async {
    var url = ROOT_URL + "/secretQuestion/secretQuestionList";
    // var url = "http://175.0.198.122:8081/secretQuestion/secretQuestionList";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      print(response.body);
      setState(() {
        questionItemList = jsonData;
      });
    } else {
      print(response.body);
    }
  }

  Future<String> addSecretQuestion1(int selectedQuestion, String ansWer) async {

    Response response;
    String url = ROOT_URL + "/secretQuestion/addSecretQuestion";
    // String url = "http://175.0.198.122:8081/secretQuestion/addSecretQuestion";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["question_id"] = selectedQuestion;
    jsonMap["answer"] = ansWer;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print("Success");
      addSecretQuestion2(selectedQuestion2, answer2.text);
      return response.body;
    } else {
      print(response.body);
      showWarningDialog(context, "Alert", "Please check your questions and answers");
      return statusCode.toString();
    }
  }

  Future<String> addSecretQuestion2(int selectedQuestion, String ansWer) async {

    Response response;
    String url = ROOT_URL + "/secretQuestion/addSecretQuestion";
    // String url = "http://175.0.198.122:8081/secretQuestion/addSecretQuestion";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["question_id"] = selectedQuestion;
    jsonMap["answer"] = ansWer;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print("Success");
      addSecretQuestion3(selectedQuestion3, answer3.text);
      return response.body;
    } else {
      print(response.body);
      showWarningDialog(context, "Alert", "Please check your questions and answers");

      return statusCode.toString();
    }
  }

  Future<String> addSecretQuestion3(int selectedQuestion, String ansWer) async {

    Response response;
    String url = ROOT_URL + "/secretQuestion/addSecretQuestion";
    // String url = "http://175.0.198.122:8081/secretQuestion/addSecretQuestion";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["account_id"] = accountInfo["account_id"];
    jsonMap["question_id"] = selectedQuestion;
    jsonMap["answer"] = ansWer;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      print("Success");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home.fromBase64(widget.jwt)));
      return response.body;
    } else {
      print(response.body);
      showWarningDialog(context, "Alert", "Please check your questions and answers");

      return statusCode.toString();
    }
  }

  Widget TA(String label, String hint, TextInputType _keyboardType, TextEditingController controller){
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: TextFormField(
        controller: controller,
        // keyboardType: _keyboardType,
        style: TextStyle(
          height: 1
        ),
        decoration: InputDecoration(
            hintText: hint,
            // hintStyle: TextStyle(color: Colors.grey),
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: InkWell(
              child: Icon(Icons.question_answer),
            ),

            // labelStyle: TextStyle( color:Colors.black ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide(color: kTextColor),
            )
        ),
      ),
    );
  }
  Widget _Button() {
    return
      Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
            width: double.infinity,
            height: 56,
            child: FlatButton(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(42, 89, 165, 1),
              onPressed: () {
                  addSecretQuestion1(selectedQuestion1, answer1.text);
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )),
      );
  }

}
