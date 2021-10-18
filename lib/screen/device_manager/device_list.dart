import 'dart:convert';
import 'dart:developer';
import 'package:LAP/screen/settings.dart';
import 'package:LAP/utilities/cons.dart';

import 'package:LAP/utilities/function.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';

class DeviceManage extends StatefulWidget {
  @override
  _DeviceManageState createState() => _DeviceManageState();
}

class _DeviceManageState extends State<DeviceManage> {
  List recentDevice = [];
  bool isLoading = false;
  bool checkBoxValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchRecent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Device Management',
          style: TextStyle(),
        ),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(5.0),
        ),
        Expanded(child: deviceList()),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
          ],
        ),
        Container(
          height: 50.0,
          child: RaisedButton(
            onPressed: () async {
              await changeDevice();
              Navigator.pop(context);
            },
            padding: EdgeInsets.all(0.0),
            child: Ink(
              color: Color.fromRGBO(13, 68, 148, 1),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Save",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  fetchRecent() async {
    setState(() {
      isLoading = true;
    });
    String url = "$ROOT_URL/device/getDeviceList/" +
        accountInfo["account_id"].toString();
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        recentDevice = items;
        isLoading = false;
      });
    } else {
      recentDevice = [];
      isLoading = false;
    }
  }

  Widget deviceList() {
    if (recentDevice.contains(null) || recentDevice.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: recentDevice.length,
        itemBuilder: (context, index) {
          return item(recentDevice[index], context, index);
        });
  }

  Future<String> deleteDevice(String _tokenDevice) async {
    final url = Uri.parse("$ROOT_URL/device/deleteDeviceManager");
    final request = http.Request("DELETE", url);
    request.headers
        .addAll(<String, String>{"Content-type": "application/json"});
    request.body = jsonEncode(
        {"account_id": accountInfo["account_id"], "token": _tokenDevice});
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Success');
      fetchRecent();
    } else {
      print(response.statusCode);
    }
  }

  Future<String> changeDevice() async {
    Response response;
    String url = "$ROOT_URL/device/updateDeviceManager";
    Map<String, String> headers = {"Content-type": "application/json"};

    Map<String, dynamic> jsonMap = new Map();
    List<Map<String, dynamic>> details = [];
    jsonMap["account_id"] = accountInfo["account_id"];
    for (int i = 0; i <= recentDevice.length - 1; i++) {
      Map<String, dynamic> detail = new Map();
      detail["token"] = recentDevice[i]["token"];
      detail["receive_noti"] = recentDevice[i]["receive_noti"];
      details.add(detail);
    }
    jsonMap["details"] = details;

    String jsonStr = JsonEncoder().convert(jsonMap);
    response = await put(url, headers: headers, body: jsonStr);
    int statusCode = response.statusCode;
    // print(jsonStr);

    if (statusCode == 200) {
      print('Success');
      return response.body;
    } else {
      print(response.body);
      return statusCode.toString();
    }
  }

  Widget item(item, BuildContext context, int index) {
    return Card(
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                (item["device_info"]
                            .toString()
                            .substring(
                                item["device_info"].toString().indexOf(',') + 1)
                            .toLowerCase() ==
                        'android')
                    ? Icons.adb
                    : Icons.phone_iphone,
                color: Color.fromRGBO(204, 204, 204, 1),
                size: 36,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: MediaQuery.of(context).size.width-110,
                  child: Text(
                    "Device : " + item["device_info"].toString().replaceAll('_', ' ').toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                SizedBox(height: 5,),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Last login : " +
                        item["last_login"].toString().substring(0, 16),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: recentDevice[index]["receive_noti"],
                        onChanged: (bool value) {
                          setState(() {
                            recentDevice[index]["receive_noti"] = value;
                          });
                        }),
                    Text('Receive notification'),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Alert"),
                          content: Text("Do you want to remove this Account ?"),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            FlatButton(
                                onPressed: () {
                                  deleteDevice(item["token"]);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Yes"))
                          ],
                        ));
              }),
        ],
      ),
    );
  }


}
