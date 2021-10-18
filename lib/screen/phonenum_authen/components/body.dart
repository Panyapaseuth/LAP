import 'package:LAP/screen/otp/otp_screen.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _number = TextEditingController();
  String initialCountry = 'LA';
  PhoneNumber phone = PhoneNumber(isoCode: 'LA');
  String getNum;

  // String number;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Your Number",
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
                  Text(
                    "Enter your mobile number to receive \na verification code",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
/*                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: phone,
                      textFieldController: _number,
                      formatInput: false,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(),
                      *//*onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },*//*
                      onSaved: (PhoneNumber number) =>
                          setState(() => getNum = number.phoneNumber),
                    ),*/

                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "+856 20 with your number",
                        prefixIcon: InkWell(
                          child: Icon(Icons.phone),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: kTextColor),
                        ),
                      ),
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Password must be at least 10 characters long';
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (value) => setState(() => getNum = value),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildContiBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'LA');

    setState(() {
      this.phone = number;
    });
  }

  Widget _buildContiBtn() {
    return SizedBox(
        width: double.infinity,
        height: 56,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color.fromRGBO(42, 89, 165, 1),
          onPressed: () {
            final isValid = _formKey.currentState.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              _formKey.currentState.save();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OtpScreen("+856" + getNum),
              ));
              print("+856" + getNum);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Next',
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
