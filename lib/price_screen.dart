import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';
  CoinData coinData = CoinData();
  String coinUrl = 'https://rest.coinapi.io/v1/exchangerate/';

  DropdownButton androidDropDownButton() {
    List<DropdownMenuItem<String>> myCurrencies = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      myCurrencies.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      dropdownColor: Colors.black87,
      iconEnabledColor: Colors.white,
      items: myCurrencies,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          updateValues();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> myPick = [];
    for (String currency in currenciesList) {
      myPick.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 48.0,
      children: myPick,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        updateValues();
      },
    );
  }

 late double convertedBTC;
  late double convertedETH;
  late double convertedLTC;

  @override
  void initState() {
    super.initState();
    updateValues();
  }
  String btc = 'BTC';
  String eth = 'ETH';
  String ltc = 'LTC';
  void updateValues() async {
    var coinResponse1 = await coinData.getCoinData(
        '$coinUrl$btc/$selectedCurrency?apikey=3B1F8DF1-9B92-4066-9224-F1B0791F71B1');
    var coinResponse2 = await coinData.getCoinData(
        '$coinUrl$eth/$selectedCurrency?apikey=3B1F8DF1-9B92-4066-9224-F1B0791F71B1');
    var coinResponse3 = await coinData.getCoinData(
        '$coinUrl$ltc/$selectedCurrency?apikey=3B1F8DF1-9B92-4066-9224-F1B0791F71B1');
    setState(() {
      convertedBTC = coinResponse1['rate'];
      convertedETH = coinResponse2['rate'];
      convertedLTC = coinResponse3['rate'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('🤑 Coin Ticker')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildPadding(btc,convertedBTC),
          buildPadding(eth,convertedETH),
          buildPadding(ltc,convertedLTC),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDownButton(),
          ),
        ],
      ),
    );
  }

  Padding buildPadding(String cryptoCoin, double convertedValue) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = $convertedValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
