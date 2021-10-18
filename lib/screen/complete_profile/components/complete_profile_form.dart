import 'dart:collection';
import 'dart:convert';

import 'package:LAP/middle_widget/AlertDialog.dart';
import 'package:LAP/screen/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:LAP/main.dart';
import 'package:LAP/screen/secret_questions/questions.dart';

class CompleteProfileFrom extends StatefulWidget {
  final String email;
  final String password;
  final String number;

  CompleteProfileFrom(this.email, this.password, this.number);

  @override
  _CompleteProfileFromState createState() => _CompleteProfileFromState();
}

enum Gender { M, F }
enum Married { False, True }

class _CompleteProfileFromState extends State<CompleteProfileFrom> {
  var _todoDateController = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();

  // String _firstname;
  // String _lastname;
  String _village;

  String _chosenValue;
  Gender gender = Gender.M;
  Married married = Married.False;

  String selectedProvince;
  List provinceItemList = List();

  String selectedDistrict;
  List districtItemList = List();

  String actualGender = "M";
  String actualMarried = 'False';

  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conform_password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getProvince();
    // this.fetchRecent();
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildName("First Name", "Enter your first name", Icons.people_alt,
              _firstname),
          SizedBox(
            height: 20,
          ),
          buildName("Last Name", "Enter your last name",
              Icons.people_alt_outlined, _lastname),
          SizedBox(
            height: 20,
          ),
          buildBirthdate(),
          SizedBox(
            height: 5,
          ),
          // Gender
          buildGender(),
          SizedBox(
            height: 5,
          ),
          // Status
          buildStatus(),
          SizedBox(
            height: 5,
          ),
          Divider(color: Colors.grey),
          Text(
            "Location",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.5,
            ),
          ),
          // Location

          buildLocation(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your village name',
                labelText: 'Village Name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value.length < 4) {
                  return 'Enter at least 4 characters';
                } else {
                  return null;
                }
              },
              onSaved: (value) => setState(() => _village = value),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildContiBtn(),
          SizedBox(
            height: 20,
          ),
          Text(
            'By continuing your confirm that you agree \nwith our Term and Condition',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  Widget buildName(String _label, String _hint, IconData icon,
          TextEditingController controller) =>
      TextFormField(
        keyboardType: TextInputType.name,
        controller: controller,
        decoration: InputDecoration(
          labelText: _label,
          hintText: _hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: InkWell(
            child: Icon(icon),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kTextColor),
          ),
        ),
/*        validator: (value) {
          if (value.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },*/
        maxLength: 30,
        // onSaved: (value) => setState(() => _value = value),
      );
  Widget buildBirthdate() => TextFormField(
        onTap: () {
          _selectedTodoDate(context);
        },
        showCursor: false,
        readOnly: true,
        controller: _todoDateController,
        decoration: InputDecoration(
          labelText: "Birth Date",
          hintText: "Pick a Date",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: InkWell(
            child: Icon(Icons.calendar_today),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: kTextColor),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select your birth date';
          } else {
            return null;
          }
        },
      );

  Widget buildGender() => Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.wc,
            color: Colors.grey,
          ),
          Radio(
            value: Gender.M,
            groupValue: gender,
            onChanged: (Gender value) {
              setState(() {
                gender = value;
                actualGender = 'M';
              });
            },
          ),
          Text("Male"),
          Radio(
            value: Gender.F,
            groupValue: gender,
            onChanged: (Gender value) {
              setState(() {
                gender = value;
                actualGender = 'F';
              });
            },
          ),
          Text("Female"),
          SizedBox(
            width: 30,
          ),
        ],
      );

  Widget buildStatus() => Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            'Status:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 25,
          ),
          Icon(
            Icons.favorite,
            color: Colors.grey,
          ),
          Radio(
            value: Married.False,
            groupValue: married,
            onChanged: (Married value) {
              setState(() {
                married = value;
                actualMarried = 'False';
              });
            },
          ),
          Text("Single"),
          Radio(
            value: Married.True,
            groupValue: married,
            onChanged: (Married value) {
              setState(() {
                married = value;
                actualMarried = 'True';
              });
            },
          ),
          Text("Married"),
        ],
      );

  Widget buildLocation() => Row(
        children: [
          Container(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 0),
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
                    // isExpanded: true,
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
          Container(
              padding: EdgeInsets.only(left: 10, top: 15, right: 10, bottom: 0),
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
                    // isExpanded: true,
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
        ],
      );

  Future getProvince() async {
    var url = ROOT_URL + "/address/province";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        provinceItemList = jsonData;
      });
    }
  }

  Future getDistrict() async {
    var url = ROOT_URL + '/address/district/' + selectedProvince;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        districtItemList = jsonData;
      });
    }
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
    jsonMap["balance"] = 10000000;
    jsonMap["user_name"] = phoneNumber.substring(4);
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

  Widget _buildContiBtn() {
    return SizedBox(
        width: double.infinity,
        height: 56,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color.fromRGBO(42, 89, 165, 1),
          onPressed:
              () /*{
            print(_firstname);
            print(_lastname);
            print(_todoDateController.text);
            print(actualGender);
            print(actualMarried);
            print(widget.email + widget.password);
            print(selectedProvince);
            print(selectedDistrict);
            print(_village);
          },*/
              async {
            final isValid = _formKey.currentState.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              _formKey.currentState.save();
              String jwt = await attemptRegister(
                  _firstname.text + _lastname.text,
                  widget.password,
                  widget.email,
                  /*balance*/ "0",
                  _firstname.text,
                  _lastname.text,
                  _todoDateController.text,
                  actualGender,
                  _village,
                  widget.number,
                  actualMarried,
                  selectedDistrict);
              storage.write(key: "jwt", value: jwt);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => Home.fromBase64(jwt)));
                      builder: (context) => SecretQuestions(jwt)));
            }else{
              showWarningDialog(context, "Alert", "This User can not sign up");
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(29,62,115,1),

                  // color: MyColors.primaryColorLight,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
          ),
        ));
  }
}
