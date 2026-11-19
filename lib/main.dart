import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  TextEditingController amount = TextEditingController();
  List<dynamic> currencies = [];
  Map<String, dynamic> values = {};
  String? sourcecurrency;
  String? targetcurrency;
  double? result;
  getData() async {
    var response = await get(
      Uri.parse(
        "https://v6.exchangerate-api.com/v6/2e88c8b0f8ce0058ef1c8d51/latest/USD",
      ),
    );
    var responsebody = jsonDecode(response.body);
    setState(() {
      values = responsebody['conversion_rates'];
      currencies = values.keys.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Converly",
            style: GoogleFonts.courgette(fontSize: 40, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
        ),
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Amount to convert",
                            style: GoogleFonts.courgette(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: amount,
                          decoration: InputDecoration(
                            hintText: "Enter the amount to convert",
                            hintStyle: GoogleFonts.courgette(
                              color: Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: Colors.grey[300],
                            filled: true,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 25),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "From : ",
                                style: GoogleFonts.courgette(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            DropdownButton(
                              underline: SizedBox(),
                              value: sourcecurrency,
                              items: currencies.map((mariam) {
                                return DropdownMenuItem<String>(
                                  value: mariam,
                                  child: Text(mariam),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  sourcecurrency = value;
                                });
                              },
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            Text(
                              "To : ",
                              style: GoogleFonts.courgette(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(height: 15),
                            DropdownButton(
                              underline: SizedBox(),
                              borderRadius: BorderRadius.circular(15),
                              value: targetcurrency,
                              items: currencies.map((toelement) {
                                return DropdownMenuItem<String>(
                                  value: toelement,
                                  child: Text(toelement),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  targetcurrency = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    double x = (values[targetcurrency] as num).toDouble();
                    double y = (values[sourcecurrency] as num).toDouble();
                    double z = double.parse(amount.text);

                    setState(() {
                      result = x / y * z;
                    });
                  },
                  child: Text(
                    "Calculate The Result",
                    style: GoogleFonts.courgette(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        "The Result After Conversion",
                        style: GoogleFonts.courgette(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$result",
                            style: GoogleFonts.courgette(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "$targetcurrency",
                            style: GoogleFonts.courgette(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${amount.text}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "$sourcecurrency",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            " = ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            "$result",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "$targetcurrency",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
