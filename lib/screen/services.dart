import 'package:LAP/middle_widget/signoff.dart';
import 'package:LAP/screen/service/fee.dart';
import 'package:LAP/screen/service/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Services extends StatelessWidget {
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
          buildMenu(() {}, true, Icons.card_giftcard, 'Promotions',
              'Special services and discounts from LAPNet', context),
          buildMenu(() => print("News"), true, Icons.feedback_sharp,
              'News', 'LAPNet activity', context),
          buildMenu(
              () => print("Location of ATM"),
              true,
              Icons.location_on_rounded,
              'Location of ATM',
              'This feature will coming in future',
              context),
          buildMenu(() { Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: ServiceFee()));}, true, Icons.money_rounded,
              'Service Fee', 'Fee charge for any LAPNet service', context),
          buildMenu(() {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: MemberPage()));
          }, true, Icons.people, 'Our members',
              'All of LAPNet Co., ltd members', context),
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
              Container(
                width: MediaQuery.of(context).size.width  - 70.0,

                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'NotoSansLao',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
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
