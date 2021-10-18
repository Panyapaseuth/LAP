import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'createCustomQR.dart';

class GenerateQR extends StatefulWidget {
  final bool customQR;
  final String amount;

  GenerateQR(this.customQR, this.amount);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GenerateQRState();
  }
}

class _GenerateQRState extends State<GenerateQR>
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
          'My QR Code',
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
                  padding: EdgeInsets.only(left: 15.0, right: 15.0,bottom: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      _buildWidget(context, widget.customQR, widget.amount)
                    ],
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

Widget _buildWidget(BuildContext context, bool customQR, String amount) {
  return Container(

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
    // height: MediaQuery.of(context).size.height-300,
    width: MediaQuery.of(context).size.width - 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(

              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    "assets/icons/lapnet.png",
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: FittedBox(
                          child: Text(
                            "ບໍລິສັດ ລາວເນເຊີນນໍ ເພເມັ້ນ ເນັດເວີກ ຈຳກັດ",
                            style: TextStyle(
                              color: Color.fromRGBO(34, 82, 148, 1),
                              fontFamily: 'NotoSansLao',
                              fontSize: 13.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 170,
                        child: FittedBox(
                          child: Text(
                            "LAO NATIONAL PAYMENT NETWORK, CO LTD",
                            style: TextStyle(
                              color: Color.fromRGBO(22, 54, 98, 1),
                              fontFamily: 'NotoSansLao',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          color: Color.fromRGBO(34, 82, 148, .5),
          child: SizedBox(
            height: 1,
            width: MediaQuery.of(context).size.width - 130,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.blueAccent),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage("$ROOT_URL/file/image/" +
                  accountInfo["account_id"].toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          accountInfo["account_name"].toString().toUpperCase(),
          style: TextStyle(
            color: Color.fromRGBO(22, 54, 98, 1),
            fontFamily: 'NotoSansLao',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        QrImage(
          data: customQR
              ? "0418LAPNETQR" +
                  accountInfo["account_id"].toString().padLeft(16, '0') +
                  amount.padLeft(16, '0')
              : "0418LAPNETQR" +
                  accountInfo["account_id"].toString().padLeft(16, '0'),
          version: QrVersions.auto,
          size: 200.0,
          embeddedImage: AssetImage('assets/icons/lapnetForQR.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(35, 35),
          ),
        ),
        SizedBox(
          height: customQR ? 0 : 10,
        ),
        customQR
            ? Text(
                amount != null ? formatDecimal(int.parse(amount)) + " LAK" : "",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontFamily: 'NotoSansLao',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              )
            : Container(),
        SizedBox(
          height: customQR ? 10 : 0,
        ),
        Text(
          accountInfo["account_id"].toString().padLeft(16, '0'),
          style: TextStyle(
            color: Color.fromRGBO(22, 54, 98, 1),
            fontFamily: 'NotoSansLao',
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateCustomQR(),
                  ));
                },
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(13, 68, 148, .9),
                        Color.fromRGBO(52, 123, 223, 1),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Create custom QR",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
