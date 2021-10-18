import 'package:LAP/screen/complete_profile/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:LAP/utilities/cons.dart';

class Body extends StatelessWidget {
  final String number;
  Body(this.number);
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
                  "Register Account",
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
                SignUpForm(number),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final String number;

  SignUpForm(this.number);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conform_password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // buildUser(),
          // SizedBox(
          //   height: 20,
          // ),
          buildPassword(),
          SizedBox(
            height: 20,
          ),
          buildConfirmPassword(),
          SizedBox(
            height: 40,
          ),
          _buildContiBtn(),
          SizedBox(
            height: 40,
          ),
          Text(
            'By continuing your confirm that you agree \nwith our Term and Condition',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );
  }

  Widget buildUser() => TextFormField(
    keyboardType: TextInputType.phone,
    readOnly: true,
    decoration: InputDecoration(
      labelText: "User Name",
      hintText: widget.number,
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /*suffixIcon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  "assets/icons/Mail.svg",
                  height: 18,
                ),
              ),*/
      prefixIcon: InkWell(
        child: Icon(Icons.person),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: kTextColor),
      ),
    ),

    onSaved: (value) => setState(() => email = value),
  );

  Widget buildEmail() => TextFormField(
    keyboardType: TextInputType.emailAddress,
    readOnly: true,
    decoration: InputDecoration(
      labelText: "Email",
      hintText: "Enter your email",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /*suffixIcon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  "assets/icons/Mail.svg",
                  height: 18,
                ),
              ),*/
      prefixIcon: InkWell(
        child: Icon(Icons.mail),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: kTextColor),
      ),
    ),
    validator: (value) {
      final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
      final regExp = RegExp(pattern);

      if (value.isEmpty) {
        return 'Enter an email';
      } else if (!regExp.hasMatch(value)) {
        return 'Enter a valid email';
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => email = value),
  );

  Widget buildPassword() => TextFormField(
    obscureText: true,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: "Password",
      hintText: "Enter your Password",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /*suffixIcon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 18,
                ),
              ),*/
      prefixIcon: InkWell(
        child: Icon(Icons.lock),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: kTextColor),
      ),
    ),
    validator: (value) {
      if (value.length < 8) {
        return 'Password must be at least 8 characters long';
      } else {
        return null;
      }
    },
    onSaved: (value) => setState(() => password = value),
  );

  Widget buildConfirmPassword() => TextFormField(
    obscureText: true,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: "Confirm Password",
      hintText: "Re-Enter your password",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /*suffixIcon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 18,
                ),
              ),*/
      prefixIcon: InkWell(
        child: Icon(Icons.lock),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: kTextColor),
      ),
    ),
    validator: (value) {
      if (value.length < 8) {
        return 'Password must be at least 8 characters long';
      }
      else {
        return null;
      }
    },
    onSaved: (value) => setState(() => conform_password = value),
  );

  Widget _buildContiBtn() {
    return SizedBox(
        width: double.infinity,
        height: 56,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color.fromRGBO(42, 89, 165, 1),
          /*onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CompleteProfile(),
            ));
          },*/
          onPressed: () {
            final isValid = _formKey.currentState.validate();
            // FocusScope.of(context).unfocus();

            if (isValid) {
              _formKey.currentState.save();

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CompleteProfile(email,password, widget.number),
              ));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Continue',
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
