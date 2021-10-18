import 'package:flutter/material.dart';
import 'components/body.dart';

class CompleteProfile extends StatefulWidget {
  final String email;
  final String password;
  final String number;
  CompleteProfile(this.email, this.password, this.number);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 89, 165, 1),
        title: Text("Sign Up"),
      ),
      body: Body(widget.email, widget.password, widget.number),
    );
  }
}
