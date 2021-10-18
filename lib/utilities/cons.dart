
import 'package:flutter/material.dart';

const ROOT_URL = 'http://'+SERVER_IP+':'+SERVER_PORT;
const SERVER_IP='175.0.198.122';
 // const SERVER_IP='192.168.0.185';
// const SERVER_PORT='8081';
const SERVER_PORT='8081';
const timeout=10;

const kTextColor = Color(0xFF757575);

Color mainBgColor1(num opacity){
  return Color.fromRGBO(28, 75, 158,opacity);
}
Color mainBgColor2(num opacity){
  return Color.fromRGBO(255,255,255,opacity);
}
Color mainTextColor1(num opacity){
  return Color.fromRGBO(255,255,255,opacity);
}
Color mainTextColor2(num opacity){
  return Color.fromRGBO(20, 49, 105,opacity);
}
Color loginTextBgColor=Color.fromRGBO(42, 89, 165,1);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);
double c_width(BuildContext context){
return MediaQuery.of(context).size.width*.87;

}

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";



final kBoxDecorationStyle = BoxDecoration(

  color: Colors.white,

  borderRadius: BorderRadius.circular(6.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: kTextColor),
  );
}