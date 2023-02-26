import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Smart Dustbin",
    home: DustbinStatus(),
  ));
}

class DustbinStatus extends StatefulWidget {
  const DustbinStatus({super.key});

  @override
  State<DustbinStatus> createState() => _DustbinStatusState();
}

bool networkconnection = true;
int b = 0;
String lastdistanceinstring = '';

class _DustbinStatusState extends State<DustbinStatus> {
  String lastdistanceinstring = "";
  var list;
  fetchsttus() async {
    var response;
    String url =
        "https://smartdustbiniicnepal.000webhostapp.com/smartdustbin/fetchdatafromserver.php";
    var uri = Uri.parse(url);
    try {
      response = await http.get(uri);
    } catch (e) {
      print('Error');
    }
    try {
      list = jsonDecode(response.body);
    } catch (e) {}

    lastdistanceinstring = list[list.length - 1]['distance'].toString();
    print(lastdistanceinstring);
    int percentageforcalculate =
        (int.parse(lastdistanceinstring) * 3.91).toInt();
    b = percentageforcalculate;
    // double finalpercent = percentageforcalculate / 3.91;
    // int newfinalpercent = finalpercent.toInt();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    fetchsttus();
    Future.delayed(const Duration(milliseconds: 500));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Smart Dustbin Status"),
      ),
      body: FutureBuilder(
          future: fetchsttus(),
          builder: (context, snapshot) {
            if (list != null) {
              return RefreshIndicator(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your Dustbin Status",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        Image.asset(
                          'assets/dustbin.png',
                          height: 60,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 50,
                    ),
                    Center(
                        child: Stack(
                      children: [
                        Container(
                          child: Text(
                            "-Your Cover-",
                            style: TextStyle(
                              backgroundColor: Color.fromRGBO(244, 67, 54, 1),
                              wordSpacing: 10,
                              letterSpacing: 5,
                              decorationColor: Colors.amber,
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          alignment: Alignment.topCenter,
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).size.height * 45 / 100,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              color: Color.fromARGB(255, 18, 155, 201)),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).size.height * 45 / 100 -
                              b.toDouble(),
                          child: Container(
                            height: b.toDouble() * 2,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Color.fromARGB(255, 9, 231, 57)),
                            child: Text(
                              "${lastdistanceinstring}" + "% ✔",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(128, 85, 21, 0),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      child: Image.asset(
                        'assets/refresh.png',
                        height: 40,
                      ),
                      onTap: () {
                        print('print');

                        setState(() {});
                      },
                    )
                  ],
                ),
                onRefresh: () {
                  return Future.delayed(Duration(seconds: (3).toInt()), () {
                    setState(() {});
                  });
                },
              );
            } else {
              return Text("Helloworld ");
            }
          }),
    );
  }
}
