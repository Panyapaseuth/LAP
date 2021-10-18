import 'dart:convert';
import 'dart:io' show Platform;
import 'package:LAP/models/Account.dart';
import 'package:LAP/screen/profile.dart';
import 'package:LAP/screen/services.dart';
import 'package:LAP/screen/settings.dart';
import 'package:LAP/screen/transfer/transfer_amount.dart';
import 'package:LAP/utilities/cons.dart';
import 'package:LAP/utilities/function.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'main_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  Home.defaultCon();

  String jwt;
  var payload;

  Home(this.jwt, this.payload) {}

  factory Home.fromBase64(String jwt) => Home(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));



  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Color.fromRGBO(28, 75, 158,1),
        title: new Text('Are you sure?',style:TextStyle(color: Colors.white)),
        content: new Text('Do you want to exit an App',style:TextStyle(color: Colors.white)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  void initState(){
    super.initState();
    setFirebaseToken();
    // getDeviceinfo();
  }

  ProgressDialog pr;

  // Properties & Variables needed

  int currentTab = 1; // to keep track of active tab index
  final List<Widget> screens = [
    MainServices(),
    Profile(),
    Services(),
    Settings(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = MainServices(); // Our first view in viewport
  Future<Account> getAccount(String userID) async {
    String url = "$ROOT_URL/account/verify/" + userID;
    Response response = await http.get(url);
    print(response.body);
    int statusCode = response.statusCode;
    if (statusCode == 200) return Account.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(58, 133, 239, 1),
        onPressed: () async {
          String cameraScanResult;

          if (Platform.isAndroid) {
            // Android-specific code
            await Permission.camera.request();
            cameraScanResult = await scanner.scan();
          } else if (Platform.isIOS) {
            // iOS-specific code
            String codeSanner = await BarcodeScanner.scan();    //barcode scnner
            setState(() {
              cameraScanResult = codeSanner;
            });
          }

          if ((cameraScanResult.length != 12+16 && cameraScanResult.length != 12+16+16) ||
              cameraScanResult.substring(0, 12) != "0418LAPNETQR") {
            print("Invalid length : "+cameraScanResult.substring(0, 12));
            return showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("Account not found"),
                      content: Text("Please try again"),
                      actions: [

                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Ok",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16),
                              ),
                            ),
                          ),

                      ],
                    ));
          }else if ((cameraScanResult.length == 12+16+16 )) {
            print(cameraScanResult.substring(12,28));
            print(cameraScanResult.substring(28));
            var account = await getAccount(cameraScanResult.substring(12,28));
            if (account != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => TransferAmount.fromQRWithAmount(account,cameraScanResult.substring(28)),
                    settings: RouteSettings(
                    //  arguments: cameraScanResult.substring(28),
                    )),
              );
            }
          }else{
            var account = await getAccount(cameraScanResult.substring(12));
            if (account != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => TransferAmount.fromQR(account),
                    settings: RouteSettings(
                      arguments: cameraScanResult.substring(12),
                    )),
              );
            }
          }

        },
        child: Container(
            child: Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(25.5),
            ),
            //color: Color.fromRGBO(11, 66, 146,1),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(13, 68, 148, 1),
                Color.fromRGBO(52, 123, 223, 1),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2 - 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = MainServices();
                            currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              currentTab == 1
                                  ? Icons.account_balance_wallet
                                  : Icons.account_balance_wallet_outlined,
                              size: currentTab == 1 ? 25 : 22,
                              color: currentTab == 1
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(255, 255, 255, .6),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Center(
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).wallet,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: currentTab == 1 ? 10 : 9,
                                    color: currentTab == 1
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(255, 255, 255, .6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = Profile();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            currentTab == 2
                                ? Icons.account_circle
                                : Icons.account_circle_outlined,
                            size: currentTab == 2 ? 25 : 22,
                            color: currentTab == 2
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(255, 255, 255, .6),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            AppLocalizations.of(context).profile,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: currentTab == 2 ? 10 : 9,
                              color: currentTab == 2
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(255, 255, 255, .6),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            currentScreen = Services();
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              currentTab == 3
                                  ? Icons.room_service
                                  : Icons.room_service_outlined,
                              size: currentTab == 3 ? 25 : 22,
                              color: currentTab == 3
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(255, 255, 255, .6),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              AppLocalizations.of(context).service,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: currentTab == 3 ? 10 : 9,
                                color: currentTab == 3
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(255, 255, 255, .6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen = Settings();
                          currentTab = 4;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            currentTab == 4
                                ? Icons.settings
                                : Icons.settings_outlined,
                            size: currentTab == 4 ? 25 : 22,
                            color: currentTab == 4
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(255, 255, 255, .6),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            AppLocalizations.of(context).settings,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: currentTab == 4 ? 10 : 9,
                              color: currentTab == 4
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(255, 255, 255, .6),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
