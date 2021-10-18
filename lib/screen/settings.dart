import 'package:LAP/middle_widget/signoff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'change_password/chg_password.dart';
import 'device_manager/device_list.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Services',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
        actions: <Widget>[
          signOff(context),
        ],
      ),
      body: ListView(
        children: <Widget>[
          buildMenu(
                  () => Navigator.push(context, PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DeviceManage(),
              )),
              true,
              Icons.devices,
              'Device Manager',
              'Special services and discounts from LAPNet',
              context),
          buildMenu(
              () => print("Notifications setting"),
              true,
              Icons.notifications_active_rounded,
              'Notifications setting',
              'Special services and discounts from LAPNet',
              context),
          buildMenu(
              () => print("Payments Limit"),
              true,
              Icons.payment,
              'Payments Limit',
              'Special services and discounts from LAPNet',
              context),
        ],
      ),
    );
  }
}

Widget buildMenu(Function ontap, bool income, IconData icon, String title,
    String des, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(217, 217, 218, .4),
          offset: Offset(0, 0),
          blurRadius: 0.5,
          spreadRadius: 0,
        )
      ],
      color: Colors.white,
    ),
    height: 100,
    child: InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20),
          Icon(
            icon,
            color: Color.fromRGBO(13, 68, 148, 1),
            size: 30.0,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'NotoSansLao',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width  - 70.0,
                child: Text(
                  des,
                  style: TextStyle(
                    color: Colors.black45,
                    fontFamily: 'NotoSansLao',
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      onTap: ontap,
    ),
  );
}
