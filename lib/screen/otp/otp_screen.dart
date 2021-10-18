import 'package:flutter/material.dart';
import 'components/body.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  OtpScreen(this.phone);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 89, 165, 1),
        title: Text("OTP Verification"),
      ),
      body: Body(widget.phone),
    );
  }
}
