import 'package:flutter/material.dart';
import 'components/body.dart';


class PhoneNumScreen extends StatefulWidget {
  @override
  _PhoneNumScreenState createState() => _PhoneNumScreenState();
}

class _PhoneNumScreenState extends State<PhoneNumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 89, 165, 1),
        title: Text("Phone Verification"),
      ),
      body: Body(),
    );
  }
}
