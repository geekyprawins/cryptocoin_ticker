import 'dart:convert';
import 'package:http/http.dart' as http;
const apiKey = '3B1F8DF1-9B92-4066-9224-F1B0791F71B1';


const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future getCoinData(String coinUrl) async{
  http.Response response =await http.get(Uri.parse(coinUrl));
  if (response.statusCode == 200) {
    String data = response.body;
    var decodedData = jsonDecode(data);
    return decodedData;
  } else
    print(response.statusCode);
  }
}
// api key =
// https://rest.coinapi.io/v1/exchangerate/BTC/INR?apikey=3B1F8DF1-9B92-4066-9224-F1B0791F71B1
// rate
