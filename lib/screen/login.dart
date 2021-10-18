import 'dart:async';
import 'dart:collection';
import 'package:LAP/screen/phonenum_authen/phonenum_screen.dart';
import 'package:LAP/widget/language_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:LAP/middle_widget/AlertDialog.dart';
import 'package:LAP/screen/home.dart';

import 'package:LAP/screen/register/register_page1.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'dart:convert' show JsonEncoder, ascii, base64, json;

import '../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ProgressDialog pr;
  bool _rememberMe = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(title: Text(title), content: Text(text)),
  );

  Future<String> attemptLogIn(String username, String password) async {
    Response response;
    //try {
    //final result = await InternetAddress.lookup("http://"+SERVER_IP);
    //  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    // print('connected');
    //try {
    String url = "$ROOT_URL/account/login";
    Map<String, String> headers = {"Content-type": "application/json"};

    LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
    jsonMap["user_name"] = username;
    jsonMap["password"] = password;
    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await post(url, headers: headers, body: jsonStr)
        .timeout(Duration(seconds: timeout));
    // } on TimeoutException catch (e) {
    //   print("timeout");
    //   return "timeout";
    // }
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      return response.body;
    } else {

      return statusCode.toString();
    }
    //   }
    // } on SocketException catch (_) {
    //   print('not connected');
    //   return "not connected";
    // }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).userName,
          style:  TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            controller: _usernameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).userName,
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color.fromRGBO(117, 146, 196,.2),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70, width: .75),
              ),
              prefixIcon: Icon(
                Icons.account_circle_rounded,
                color: Colors.white38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).password,
          style:  TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            textAlign: TextAlign.start,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).password,
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color.fromRGBO(117, 146, 196,.2),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: .5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70, width: .75),
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white38,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      height: 20,
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          AppLocalizations.of(context).forgotPassword,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Color.fromRGBO(117, 146, 196, 1)),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Color.fromRGBO(28, 75, 158,1),
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            AppLocalizations.of(context).rememberUserName,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
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

  Widget _buildLoginBtn() {
    return  RaisedButton(

      onPressed: () async {
        try{
          await pr.show();
          var username = _usernameController.text;
          var password = _passwordController.text;
          var jwt = await attemptLogIn(username, password);

          if (jwt != null) {
            await pr.hide();
            if (jwt == "timeout" || jwt == "not connected") {
              showWarningDialog(context, AppLocalizations.of(context).error404Title, AppLocalizations.of(context).error404Str);

            } else if (jwt == "401") {
              showWarningDialog(context,AppLocalizations.of(context).errorUserTitle, AppLocalizations.of(context).errorUserStr) ;

            } else if (jwt == "400") {
              showWarningDialog(context, "400", "400");

            } else {
              await pr.hide();
              storage.write(key: "jwt", value: jwt);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home.fromBase64(jwt)));
            }
          } else {
            await pr.hide();
          }

        } on TimeoutException{
          await pr.hide();
          showWarningDialog(context, AppLocalizations.of(context).error404Title, AppLocalizations.of(context).error404Str);
        }

      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: mainBgColor2(1.0)),
      ),
      padding: EdgeInsets.only(left: 80,right: 80,top: 12,bottom: 12),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          AppLocalizations.of(context).login,
          textAlign: TextAlign.center,
          style: TextStyle(color: mainTextColor2(1.0), fontSize: 16),
        ),

      ),

    );

  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhoneNumScreen(),
        ));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context).dontHaveAcc,
              style: TextStyle(
                color: mainTextColor1(.7),
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: AppLocalizations.of(context).signUp,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: AppLocalizations.of(context).loading,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 77, 160,1),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.centerRight,
                child:LanguagePickerWidget()),
            Container(
                child: new Image.asset(
                  'assets/logos/logo.png',
                  height: 80,
                  fit: BoxFit.cover,
                )),
            SizedBox(height: 45.0),
            _buildEmailTF(),
            SizedBox(
              height: 15.0,
            ),
            _buildPasswordTF(),
            SizedBox(
              height: 10.0,
            ),
            _buildRememberMeCheckbox(),
            _buildForgotPasswordBtn(),
            SizedBox(
              height: 20,
            ),
            _buildLoginBtn(),
            SizedBox(
              height: 30,
            ),
            _buildSignupBtn(),
          ],
        ),
      ),
    );
  }
}
