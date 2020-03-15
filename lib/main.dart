import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'package:corona/detail.dart';
import 'package:corona/model/corona.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flag/flag.dart';

void main() => runApp(MyApp());

Future<Corona> fetchDataConfirmed() async {
  final response = await http.get(
    "https://coronavirus-tracker-api.herokuapp.com/confirmed",
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Confirmed.fromJson(json.decode(response.body));
    //print(jsonDecode(response.body));
    return Corona.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Data');
  }
  //print("ASD");
  // print(response.body);
  //return Confirmed.fromJson(json.decode(response.body));
}

Future<Corona> fetchDataDeath() async {
  final response = await http.get(
    "https://coronavirus-tracker-api.herokuapp.com/deaths",
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Confirmed.fromJson(json.decode(response.body));
    //print(jsonDecode(response.body));
    return Corona.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Data');
  }
  //print("ASD");
  // print(response.body);
  //return Confirmed.fromJson(json.decode(response.body));
}

Future<Corona> fetchDataRecovered() async {
  final response = await http.get(
    "https://coronavirus-tracker-api.herokuapp.com/recovered",
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Confirmed.fromJson(json.decode(response.body));
    //print(jsonDecode(response.body));
    return Corona.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Data');
  }
  //print("ASD");
  // print(response.body);
  //return Confirmed.fromJson(json.decode(response.body));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID Live',
      theme: ThemeData(primarySwatch: Colors.green),
      home: CoronaHomePage(),
    );
  }
}

class CoronaHomePage extends StatefulWidget {
  @override
  _CoronaHomePageState createState() => _CoronaHomePageState();
}

class _CoronaHomePageState extends State<CoronaHomePage> with SingleTickerProviderStateMixin {
  Future<Corona> confirm;
  Future<Corona> death;
  Future<Corona> recovered;
  TabController _tabController;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var refreshKey2 = GlobalKey<RefreshIndicatorState>();
  var refreshKey3 = GlobalKey<RefreshIndicatorState>();
  String search = "";
  final TextEditingController searchController = new TextEditingController();
  //bool refresh = false;

  Future<Void> refreshList() async {
    confirm = fetchDataConfirmed();
    death = fetchDataDeath();
    recovered = fetchDataRecovered();
    await Future.delayed(Duration(seconds: 2));

    this.setState(() {
      search = "";
      this.searchController.clear();
    });
    //network call and setState so that view will render the new values
    print("refresh");
  }

  @override
  void initState() {
    // TODO: implement initState
    //confirm = fetchData();
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    confirm = fetchDataConfirmed();
    death = fetchDataDeath();
    recovered = fetchDataRecovered();
    // var format = DateFormat.yMd('id');
    // var dateString = format.format(DateTime.now());
    // print(dateString);
    //Intl.defaultLocale = 'es';
    //var date = DateFormat.jm().format(DateTime.now());
    //print(date);
  }

  /*Future<List<Confirmed>> parseConfirmed(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Confirmed>((json) => Confirmed.fromJson(json)).toList();
  }*/
  /*Future fetchDataCorona() async {
    confirm = await fetchData();
  }*/
  String dateFormat(DateTime date) {
    var formatter = new DateFormat.yMMMMd('en_US');
    var formatter2 = new DateFormat("HH:mm:ss");
    String result = formatter.format(date) + " " + formatter2.format(date);
    return result;
  }

  String dateFormat2(DateTime date) {
    var formatter = new DateFormat.yMMMMd('en_US');
    String result = formatter.format(date);
    return result;
  }

  String numberFormat(double value) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
        amount: value,
        settings: MoneyFormatterSettings(
          symbol: 'IDR',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 0,
          compactFormatType: CompactFormatType.short,
        ));
    String result = fmf.output.nonSymbol;
    return result;
  }

  Widget corona(Future temp) {
    Widget confirmed = Container(
      child: FutureBuilder<Corona>(
          future: temp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.hasError);
              return Container(
                color: Colors.black87,
                child: Center(child: Text("Eror")),
              );
            } else if (snapshot.hasData) {
              return SafeArea(
                child: Container(
                  color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 2, left: 2.0, right: 2.0),
                        child: Container(
                          color: Colors.black87,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                          controller: searchController,
                                          onChanged: (value) {
                                            setState(() {
                                              search = value;
                                            });
                                          },
                                          cursorColor: Colors.green,
                                          decoration: InputDecoration(
                                            hintText: 'Search',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                            fillColor: Colors.grey[500],
                                            //filled: true,
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: Colors.black,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                child: Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    color: Colors.greenAccent,
                                    child: Text(
                                      "Reset Search",
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                    onPressed: () {
                                      //this.searchController.clear();
                                      this.setState(() {
                                        search = "";
                                        this.searchController.clear();
                                        //searchController.text
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Total Result",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                        ),
                                        Text(
                                          numberFormat(snapshot.data.latest.toDouble()),
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Update",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                        ),
                                        Text(
                                          dateFormat(snapshot.data.last_updated),
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 1),
                      /*Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Container(
                          color: Colors.black87,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Country",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Result",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                      Expanded(
                        //height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            color: Colors.black87,
                            child: Scrollbar(
                              child: ListView.builder(
                                  itemCount: snapshot.data.locations?.length,
                                  itemBuilder: (context, index) {
                                    if (snapshot.data.locations != null && (search != "" && snapshot.data.locations[index].country.toLowerCase().contains(search.toLowerCase()))) {
                                      return content(snapshot.data, index);
                                    } else if (snapshot.data.locations != null && search == "") {
                                      return content(snapshot.data, index);
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(color: Colors.black87, child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
    return confirmed;
  }

  Widget content(Corona temp, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, right: 2.0, left: 4.0, bottom: 2),
      child: Card(
          elevation: 10,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //SizedBox(height: 10),
                Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flags.getMiniFlag(temp.locations[index].country_code.toString(), 60, 60),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                temp.locations[index].country,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              child: Text(
                                temp.locations[index].province,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Result : ",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    numberFormat(temp.locations[index].latest.toDouble()),
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(height: 10),
                      IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Detail(
                                        location: temp.locations[index],
                                      )),
                            );
                          }),
                    ]),
                /*Column(
                  children: <Widget>[
                    Container(
                      color: Colors.greenAccent,
                      child: ListView.builder(
                        itemCount: temp.locations[index]?.history?.length,
                        itemBuilder: (context, index2) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(dateFormat2(temp.locations[index].history[index2].date)),
                              Text(temp.locations[index].history[index2].victim.toString()),
                            ],
                          );
                        },
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ),*
                  ],
                )*/
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "COVID Live Report",
            style: TextStyle(color: Colors.greenAccent),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            //labelColor: Colors.greenAccent,
            //isScrollable: true,
            tabs: [
              Tab(
                icon: Center(
                  child: Text(
                    "Recovered",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                  ),
                ),
              ),
              Tab(
                  icon: Text(
                "Infected",
                style: TextStyle(color: Colors.greenAccent, fontSize: 14),
              )),
              Tab(
                  icon: Text(
                "Death",
                style: TextStyle(color: Colors.greenAccent, fontSize: 14),
              )),
            ],
            controller: _tabController,
            indicatorColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
        ),
        bottomNavigationBar: Container(
            height: 45,
            color: Colors.black87,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8),
                Center(
                    child: Text(
                  "Data Repository, provided by JHU CCSE",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.greenAccent,
                  ),
                )),
                Text(
                  "Thanks to https://github.com/ExpDev07/coronavirus-tracker-api",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.greenAccent,
                  ),
                )
              ],
            )),
        body: TabBarView(
          children: <Widget>[
            RefreshIndicator(
              backgroundColor: Colors.black87,
              color: Colors.greenAccent,
              child: corona(recovered),
              onRefresh: refreshList,
              key: refreshKey,
            ),
            RefreshIndicator(
              backgroundColor: Colors.black87,
              color: Colors.greenAccent,
              child: corona(confirm),
              onRefresh: refreshList,
              key: refreshKey2,
            ),
            RefreshIndicator(
              backgroundColor: Colors.black87,
              color: Colors.greenAccent,
              child: corona(death),
              onRefresh: refreshList,
              key: refreshKey3,
            ),
            //corona(confirm),
            //corona(death),
          ],
          controller: _tabController,
        ));
  }
}
