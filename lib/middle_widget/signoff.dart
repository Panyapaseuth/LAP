import 'package:LAP/screen/login.dart';
import 'package:flutter/material.dart';

signOff(BuildContext  context){
 return IconButton(
      icon: Icon(
        Icons.power_settings_new_rounded,
        color: Color.fromRGBO(255, 255, 255, .8),
      ),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
}

