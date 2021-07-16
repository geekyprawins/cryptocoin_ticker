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
      isDense: true,
      value: selectedCurrency,
      dropdownColor: Colors.lightBlueAccent,
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

  var convertedBTC = 0.0;
  var convertedETH = 0.0;
  var convertedLTC = 0.0;

  @override
  void initState() {
    super.initState();
    updateValues();
  }

  String btc = 'BTC';
  String eth = 'ETH';
  String ltc = 'LTC';
  void updateValues() async {
    var coinResponse1 = await coinData
        .getCoinData('$coinUrl$btc/$selectedCurrency?apikey=$apiKey');
    var coinResponse2 = await coinData
        .getCoinData('$coinUrl$eth/$selectedCurrency?apikey=$apiKey');
    var coinResponse3 = await coinData
        .getCoinData('$coinUrl$ltc/$selectedCurrency?apikey=$apiKey');
    setState(() {
      convertedBTC = coinResponse1['rate'];
      convertedETH = coinResponse2['rate'];
      convertedLTC = coinResponse3['rate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return (convertedBTC != 0.0 || convertedETH != 0.0 || convertedLTC != 0.0)
        ? Scaffold(
            appBar: AppBar(
              title: Center(child: Text('🤑 Coin Ticker')),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildPadding(btc, convertedBTC),
                buildPadding(eth, convertedETH),
                buildPadding(ltc, convertedLTC),
                Container(
                  height: 100.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 10.0),
                  color: Colors.lightBlue,
                  child: Platform.isIOS ? iosPicker() : androidDropDownButton(),
                ),
              ],
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('🤑 Coin Ticker'),
              ),
              bottomSheet: Container(
                height: 100.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 10.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iosPicker() : androidDropDownButton(),
              ),
              body: Padding(
                padding: EdgeInsets.only(left: 55.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.orangeAccent,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      'Hang on, fetching current prices...',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Padding buildPadding(String cryptoCoin, double convertedValue) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.orangeAccent,
        elevation: 15.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19.0),
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
