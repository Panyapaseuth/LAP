import 'package:flutter/material.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  final String number;

  SignUpScreen(this.number);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 89, 165, 1),
        title: Text("Sign Up"),
      ),
      body: Body(widget.number),
    );
  }
}
