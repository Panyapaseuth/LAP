import 'dart:convert';
import 'package:LAP/screen/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:LAP/screen/complete_profile/components/complete_profile_form.dart';

class Body extends StatelessWidget {
  final String email;
  final String password;
final String number;
  Body(this.email, this.password, this.number);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Complete Profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    Text(
                      "Complate your details or continue \nwith social media",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CompleteProfileFrom(email, password, number),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

