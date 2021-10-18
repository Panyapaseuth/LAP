import 'package:LAP/screen/sign_up/sign_up1.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatelessWidget {
  final String phone;

  Body(this.phone);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("We sent your code to $phone"),
                buildTimer(),
                SizedBox(
                  height: 30,
                ),
                OtpForm(phone),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 120.0, end: 0.0),
          duration: Duration(seconds: 120),
          builder: (_, value, child) => Text(
            "${value.toInt()}",
            style: TextStyle(color: kTextColor),
          ),
        ),
      ],
    );
  }
}

class OtpForm extends StatefulWidget {
  final String phone;

  OtpForm(this.phone);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
  String _verificationCode;

  @override
  void initState() {
    super.initState();
    this._verifyPhone();
    print('${widget.phone}');

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PinCodeTextField(
            appContext: context,
            pastedTextStyle: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
            length: 6,
/*            obscureText: true,
            obscuringCharacter: '*',
            obscuringWidget: FlutterLogo(
              size: 24,
            ),
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,*/
            validator: (v) {
              if (v.length < 6) {
                return "Enter 6 digit";
              } else {
                return null;
              }
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              inactiveFillColor: Colors.white,
              inactiveColor: Colors.grey,
              activeColor: Colors.blue,
              activeFillColor: Colors.white,
            ),
            cursorColor: Colors.black,
            // animationDuration: Duration(milliseconds: 300),
            enableActiveFill: true,
/*          errorAnimationController: errorController,*/
            controller: pinController,
            keyboardType: TextInputType.number,
            boxShadows: [
              BoxShadow(
                offset: Offset(0, 1),
                color: Colors.black12,
                blurRadius: 10,
              )
            ],
            onCompleted: (v) {
              print("Completed");
            },
            // onTap: () {
            //   print("Pressed");
            // },
            onChanged: (value) {
              print(value);
              setState(() {
                // currentText = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
          SizedBox(
            height: 30,
          ),
          _buildContiBtn()
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpScreen(widget.phone)),
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
            */ /*Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignUpScreen(widget.number),
            ));*/ /*
            print("Pin = " + pinController.text);
          },*/

              async {
            final isValid = _formKey.currentState.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              _formKey.currentState.save();
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              final code = pinController.text.trim();
              await FirebaseAuth.instance
                  .signInWithCredential(PhoneAuthProvider.credential(
                  verificationId: _verificationCode, smsCode: code))
                  .then((value) async {
                if (value.user != null) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen(widget.phone)),
                          (route) => false);
                }
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Verify',
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
