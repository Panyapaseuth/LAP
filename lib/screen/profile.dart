import 'package:LAP/middle_widget/signoff.dart';
import 'package:LAP/screen/upload/uploadpic.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'QR/generateQR.dart';
import 'change_password/chg_password.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    void _showQRPage() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GenerateQR(false, null),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context).profile,
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
        actions: <Widget>[
          signOff(context),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20,bottom: 20),
            //height: 230.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(13, 68, 148, 1),
                  Color.fromRGBO(52, 123, 223, 1),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: _accountInfo(context, accountInfo),
          ),
          profileList(() {
            imageCache.clear();
            imageCache.clearLiveImages();
            setState(() {

            });

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UploadPic(),
            ));

          },
              true,
              Icons.account_circle,
              AppLocalizations.of(context).changeProfileTitle,
              AppLocalizations.of(context).changeProfileDesc,
              context),
          profileList(() {
            _showQRPage();
          }, true, Icons.qr_code, AppLocalizations.of(context).myQRTitle,
              AppLocalizations.of(context).myQRDesc, context),
          profileList(
              () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  )),
              true,
              Icons.vpn_key,
              AppLocalizations.of(context).changePassTitle,
              AppLocalizations.of(context).changePassDesc,
              context),
        ],
      ),

    );
  }
}

Widget profileList(Function ontap, bool income, IconData icon, String title,
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
              Text(
                des,
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'NotoSansLao',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
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

Widget _accountInfo(BuildContext context, Map<String, dynamic> accountInfo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Stack(children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.white),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage("$ROOT_URL/file/image/" +
                    accountInfo["account_id"].toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: InkWell(
              onTap: () => {

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UploadPic(),
                ))
              },
            ),
          ),
          Positioned(bottom: 5,right: 5, child: buildEditIcon(context))
        ]),
      ),
      //
      // Icon(
      //   Icons.account_circle,
      //   size: 120,
      //   color: Colors.white,
      // ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        accountInfo["account_id"].toString().padLeft(16, "0"),
        style: TextStyle(color: Colors.white70),
      ),
      SizedBox(
        height: 10.0,
      ),
      Text(
        accountInfo["account_name"].toString(),
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
  );
}

Widget buildEditIcon(BuildContext context) {
  return buildCircle(
    color: Colors.white,
    all:1.5,
    child: buildCircle(
      color: Colors.blueAccent,
      all:3 ,
      child: SizedBox(
        height: 24.0,
        width: 24.0,
        child: IconButton(
          padding: new EdgeInsets.all(0.0),
          icon: const Icon(Icons.edit),
          color: Colors.white,
          iconSize: 18,
          onPressed: () {  Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UploadPic(),
          ));},),
      ),
    ),
  );
}

Widget buildCircle({
  Widget child,
   double all,
   Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );

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
