import 'package:corona/model/corona.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  Location location;
  Detail({this.location});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Detail ",
            style: TextStyle(color: Colors.greenAccent),
          ),
          centerTitle: true,
          elevation: 0,
          //bottomOpacity: 1,
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
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.greenAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: widget.location.history?.length,
                    itemBuilder: (context, index2) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            dateFormat2(widget.location.history[index2].date),
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            numberFormat(widget.location.history[index2].victim.toDouble()),
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
