import 'package:flutter/material.dart';

class LeasingPayment extends StatefulWidget {
  LeasingPayment({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LeasingPayment>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Leasing Payments',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: <Widget>[listOfService(context)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget listOfService(BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        SizedBox(height: 16),
        Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildService(() => print('Bill Payment'), 'AEON',
                  'assets/icons/AEON.jpg', 45, context),
              _buildService(() => print('Bill Payment'), 'Krungsri',
                  'assets/icons/KRUNGSRI.png', 45, context),
            ],
          ),

          
          SizedBox(height: 16),
        ])
      ],
    ),
  );
}

Widget topUp = Container();

Widget _buildService(Function onTap, String serviceName, String icon, double h,
    BuildContext context) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(217, 217, 218, .4),
            offset: Offset(10, 2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
        color: Colors.white,
      ),
      height: MediaQuery.of(context).size.width / 3 - 20.0,
      width: MediaQuery.of(context).size.width / 3 - 20.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Container(
              child: new Image.asset(
                icon,
                height: h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            serviceName,
            style: TextStyle(
              color: Colors.black45,
              fontFamily: 'NotoSansLao',
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
