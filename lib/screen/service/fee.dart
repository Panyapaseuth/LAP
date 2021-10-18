import 'dart:convert';

import 'package:LAP/utilities/cons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceFee extends StatefulWidget {
  @override
  _ServiceFeeState createState() => _ServiceFeeState();
}

class _ServiceFeeState extends State<ServiceFee> {
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
      var items = json.decode(Utf8Decoder().convert(response.bodyBytes));
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

    // fetData();
  }

  @override
  Widget build(BuildContext context) {
    Widget getBody() {
      if (member.contains(null) || member.length < 0 || isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '    1. ທ່ານສາມາດຖອນເງີນສົດຜ່ານຕູ້ ATM ໂດຍໃຊ້ບັດຂອງທຸກໆທະນາຄານທີ່ເປັນສະມາຊິກຂອງ LAPNet ແລະ ຖອນຜ່ານຕູ້ຂອງທະນາຄານໃດກໍ່ໄດ້ທີ່ເປັນສະມາຊິກຂອງ LAPNet'),
          ),
          buildATMCWFee(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '    2. ທ່ານສາມາດໂອນເງີນຜ່ານຕູ້ ATM ຈາກທຸກໆທະນາຄານທີ່ເປັນສະມາຊິກຂອງ LAPNet ແລະ ຫາທຸກໆທະນາຄານທີ່ເປັນສະມາຊິກຂອງ LAPNet ພາຍໃຕ້ວົງເງິນແຕ່ 1.000 ກີບ ຫາ 10.000.000 ກີບ/ຄັ້ງ ແລະ ໂອນເງິນສູງສຸດ 50.000.000 ກີບ/ວັນ. ໂດຍຈະຄິດໄລ່ຄ່າບໍລິການຕາມມູນຄ່າການໂອນດັ່ງນີ້:'),
          ),
          buildATMCWFee2(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '    3. ທ່ານສາມາດໂອນເງີນຜ່ານ Mobile banking application ຈາກທຸກໆທະນາຄານທີ່ເປັນສະມາຊິກຂອງ LAPNet ແລະ ຫາທຸກໆທະນາຄານທີ່ເປັນສະມາຊິກຂອງ LAPNet'),
          ),
          buildATMCWFee3(),
          SizedBox(
            height: 20,
          ),
        ],
      );
    }


    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Service Fee"),
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
                child: Image(
                  image: NetworkImage(
                      '$ROOT_URL/member/image/' + item["sort_name"]),
                ),
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
                      item["atm"]
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: item["atm"]
                          ? Color.fromRGBO(13, 68, 148, 1)
                          : Colors.grey,
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
                      item["mobile"]
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: item["mobile"]
                          ? Color.fromRGBO(13, 68, 148, 1)
                          : Colors.grey,
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

  Widget buildATMCWFee() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(28, 75, 158, .8),
              child: Center(
                  child: Text(
                'ຄ່າທຳນຽມການຖອນເງິນຜ່ານ ATM',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              )),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10))
                ]),
            child:
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('2.000 ກີບ/ຄັ້ງ', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,)),
                  ),
                ),
            
          )
        ],
      ),
    );
  }

  Widget buildATMCWFee2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(28, 75, 158, .8),
              child: Center(
                child: Text(
                  'ຄ່າທຳນຽມໂອນເງິນຜ່ານ ATM',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ແຕ່ຈຳນວນເງິນ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('1.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('1.500.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('5.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຫາຈຳນວນ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('1.500.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('5.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('10.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຄ່າບໍລິການ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('1.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('2.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('10.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildATMCWFee3() {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(28, 75, 158, .8),
              child: Center(
                child: Text(
                  'ຄ່າທຳນຽມໂອນເງິນຜ່ານມືຖື',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ແຕ່ຈຳນວນເງິນ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('1 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('2.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('4.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('5.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('7.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('10.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('30.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('50.000.001 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຫາຈຳນວນ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('2.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('4.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('5.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('7.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('10.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('30.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('50.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('100.000.000 ກີບ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ຄ່າບໍລິການ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('1.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('1.500 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('2.500 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('3.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('4.500 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('7.500 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('12.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('15.500 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                        Text('20.000 ກີບ/ຄັ້ງ'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
