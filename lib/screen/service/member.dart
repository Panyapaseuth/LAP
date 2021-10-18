import 'dart:convert';

import 'package:LAP/utilities/cons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;


class MemberPage extends StatefulWidget {

  @override
  _MemberPageState createState() => _MemberPageState();


}


class _MemberPageState extends State<MemberPage> {


  List member = [];
  bool isLoading = false;
  fetData() async {
    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {
      isLoading = true;
    });
    var url = "$ROOT_URL/member";
    var response = await http.get(url);

    if (response.statusCode == 200) {

      var items = json.decode( Utf8Decoder().convert(response.bodyBytes));
      setState(() {
        member = items;
        isLoading = false;
      });
    } else {
      member = [];
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetData();
  }
  @override
  Widget build(BuildContext context) {



    Widget getBody() {
      if (member.contains(null) || member.length < 0 || isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: member.length + 1,
          itemBuilder: (context, index) {
            if (index == member.length) {
              return null;
            }
            return buildMemberCard(member[index]);
          });
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Our members"),
        backgroundColor: Color.fromRGBO(13, 68, 148, 1),
      ),
      body: getBody(),
    );
  }

  Widget buildMemberCard(item) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10))
            ]),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 80,
                height: 80,
                child: Image(image: NetworkImage('$ROOT_URL/member/image/'+item["sort_name"]),),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["sort_name"],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                Linkify(
                  onOpen: (link) => print("Clicked ${link.url}!"),
                  text: item["website"],
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  linkStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  item["contact"],
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    Icon(
                      item["atm"] ? Icons.check_box : Icons.check_box_outline_blank,
                      color: item["atm"] ? Color.fromRGBO(13, 68, 148, 1) : Colors.grey,
                    ),
                    Text(
                      'ATM Pool',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      item["mobile"] ? Icons.check_box : Icons.check_box_outline_blank,
                      color:
                      item["mobile"] ? Color.fromRGBO(13, 68, 148, 1) : Colors.grey,
                    ),
                    Text(
                      'Mobile Payment',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
