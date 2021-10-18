import 'package:LAP/screen/register/register_page3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegisterPage2 extends StatefulWidget {
  final String phoneNumber;
  RegisterPage2(this.phoneNumber);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPage2State();
  }
}

class _RegisterPage2State extends State<RegisterPage2> {
  TextEditingController OTP = TextEditingController();

  String _verificationCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._verifyPhone();
    print(widget.phoneNumber);
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
            'OTP',
            style: TextStyle(color: Colors.black54),
          ), centerTitle: true,
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
                      _TF("OTP", TextInputType.number,OTP),
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
            onPressed: () async{
              if (OTP.text.isEmpty) {
                showDialog(context: context, builder: (_) => alertDialog("Value Empty","Please Input your OTP to the Text"));
              } else {
                /*Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RegisterPage3(widget.phoneNumber),
                ));*/
                try {
                  final code = OTP.text.trim();
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: code))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage3(widget.phoneNumber)),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  showDialog(context: context, builder: (_) => alertDialog("Wrong OTP","Invalid OTP"));
                  print("Invalid OTP");
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

  Widget _TF(String _hintText, TextInputType _keyboardType,TextEditingController controller) {
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
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
                style: TextStyle(
                  height: 1,
                )),
          ],
        ));
  }
  alertDialog(String title,String content) {
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

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+85620${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage3(widget.phoneNumber)),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }
}