import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:LAP/models/Account.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info/device_info.dart';

import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io' show Platform;
import 'cons.dart';

String repeatStringNumTimes(string, times) {
  var repeatedString = "";
  while (times > 0) {
    if(repeatedString=="")
    repeatedString += string;
    else repeatedString += repeatedString;
    times--;
  }
  return repeatedString;
}

String formatDecimal(int number) {
  if (number > -1000 && number < 1000) return number.toString();

  final String digits = number.abs().toString();
  final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
  final int maxDigitIndex = digits.length - 1;
  for (int i = 0; i <= maxDigitIndex; i += 1) {
    result.write(digits[i]);
    if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) result.write(',');
  }
  return result.toString();
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  final String result = formatter.format(date);
  return result;
}
extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}

Map<String, dynamic> accountInfo;

Future<Map<String, dynamic>> getAccountInfo() async {
  var jwt = await storage.read(key: "jwt");
  accountInfo = json.decode(
    ascii.decode(
      base64.decode(
        base64.normalize(jwt.split(".")[1]),
      ),
    ),
  );
  return accountInfo;
}

Future<int> getBalance(String accountID) async {
  String url = "$ROOT_URL/account/balance/" + accountID;
  var response = await http.get(url);
  Account account= Account.fromJson(jsonDecode(response.body));

  return account.balance;
}

Future<void> sendNotification(String targetAcc,String title, String body) async {
  String url = ROOT_URL + "/device/sendNotification";
  Map<String, String> headers = {"Content-type": "application/json"};

  LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
  jsonMap["accountID"] = targetAcc;
  jsonMap["title"] = title;
  jsonMap["body"] = body;
  String jsonStr = JsonEncoder().convert(jsonMap);
  await post(url, headers: headers, body: jsonStr)
      .timeout(Duration(seconds: timeout));
}

bool isNumericUsing_tryParse(String string) {
  // Null or empty string is not a number
  if (string == null || string.isEmpty) {
    return false;
  }

  // Try to parse input string to number.
  // Both integer and double work.
  // Use int.tryParse if you want to check integer only.
  // Use double.tryParse if you want to check double only.
  final number = int.tryParse(string.replaceAll(',', ''));

  if (number == null) {
    return false;
  }

  return true;
}

Future<void> setFirebaseToken() async {
  FirebaseMessaging firebaseMessaging= FirebaseMessaging();
  String token= await firebaseMessaging.getToken();
  var device = DeviceInfoPlugin();
  var deviceInfo ;
  if(Platform.isAndroid)
    deviceInfo= await device.androidInfo;
  else  if(Platform.isIOS)
    deviceInfo= await device.iosInfo;
  else deviceInfo=null;
  Response response;
  String url = ROOT_URL + "/device/setDeviceToken";
  Map<String, String> headers = {"Content-type": "application/json"};

  LinkedHashMap<String, dynamic> jsonMap = new LinkedHashMap();
  jsonMap["account_id"] = accountInfo["account_id"];
  jsonMap["token"] = token;
  jsonMap["device_info"] = Platform.isAndroid?deviceInfo.model+',android':deviceInfo.model+',ios';
  String jsonStr = JsonEncoder().convert(jsonMap);
  response = await put(url, headers: headers, body: jsonStr)
      .timeout(Duration(seconds: timeout));
  int statusCode = response.statusCode;
  if (statusCode == 200) {
     print('success '+response.body);
    return response.body;
  } else {
     print('failed '+response.body);
    return statusCode.toString();
  }
}

Future<void> getDeviceinfo() async {
  var device = DeviceInfoPlugin();
  if (Platform.isAndroid){
    var androidInfo = await device.androidInfo;
    print('Running on ${androidInfo.model}');
  }
  else if (Platform.isIOS){
    var iosInfo = await device.iosInfo;
    print('Running on ${iosInfo.model}');

  }
}


