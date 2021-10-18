
import 'package:LAP/middle_widget/signoff.dart';
import 'package:LAP/screen/payment_screen/bill_payment/bill_payment.dart';
import 'package:LAP/screen/payment_screen/leasing_payment/leasing_payment.dart';
import 'package:LAP/screen/payment_screen/phone_payment/phone_payment.dart';
import 'package:LAP/screen/payment_screen/tax_payment/tax_payment_list.dart';
import 'package:LAP/screen/payment_screen/water_payment/water_payment.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'history_screen/history.dart';
import 'payment_screen/electricity_payment/electricity_payment.dart';
import 'transfer/Transfer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainServices extends StatefulWidget {
  MainServices({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainServices>
    with SingleTickerProviderStateMixin {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'LAP Wallet',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
        actions: <Widget>[
          signOff(context),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 120.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(13, 68, 148, .9),
                  Color.fromRGBO(52, 123, 223, .9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: FutureBuilder(
                  future: getAccountInfo(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _accountInfo(snapshot.data);
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),

          ),
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
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: History()));
                //
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => History(),
                // ));
              }, AppLocalizations.of(context).history, 'assets/icons/history.png', 45, context),
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  AccountList(),
                ));
              },  AppLocalizations.of(context).transfer, 'assets/icons/transfer.png', 45, context),
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  TaxPaymentList(),
                ));
              },  AppLocalizations.of(context).tax, 'assets/icons/tax.png', 45, context),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  ElectricityPayment(),
                ));
              },  AppLocalizations.of(context).electricity, 'assets/icons/electric.png', 45,
                  context),
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  WaterPayment(),
                ));
              },  AppLocalizations.of(context).water, 'assets/icons/water.png', 45, context),
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: BillPayment(),
                ));
              },  AppLocalizations.of(context).bill, 'assets/icons/billpayment.png', 45, context),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: PhonePayment(),
                ));
              },  AppLocalizations.of(context).phone, 'assets/icons/phone.png', 45, context),
              _buildService(() => print('Topup'),  AppLocalizations.of(context).topup,
                  'assets/icons/topup.png', 45, context),
              _buildService(() {
                Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: LeasingPayment(),
                ));
              },  AppLocalizations.of(context).leasing, 'assets/icons/leasing.png', 45, context),
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
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
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

Widget _accountInfo(Map<String, dynamic> accountInfo) {
  return Row(
    children: [
      SizedBox(
        width: 12.0,
      ),
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Colors.white),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage("$ROOT_URL/file/image/" +
                accountInfo["account_id"].toString()),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 12.0,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (accountInfo != null)
                ? accountInfo["account_id"].toString().padLeft(16, '0')
                : "",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            (accountInfo != null) ? accountInfo["account_name"] : "",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
            future: getBalance(accountInfo["account_id"].toString()),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _balance(snapshot.data);
              } else {
                return _balanceProgress();
              }
            },
          ),
        ],
      ),
      SizedBox(
        width: 10.0,
      ),
    ],
  );
}

Widget _balance(var balance) {
  return Text(
    (balance != null) ? formatDecimal(balance.round()) + " LAK" : ". . .",
    style: TextStyle(color: Colors.white, fontSize: 24),
  );
}

Widget _balanceProgress() {
  return Column(children: [
    SizedBox(
      height: 10.0,
    ),
    SizedBox(
      child: CircularProgressIndicator(),
      height: 10.0,
      width: 10.0,
    )
  ]);
}
