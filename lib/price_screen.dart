import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:bitcoin_ticker/services/cryptoPrice.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";
  bool isWaiting = true;
  int currencyPrice;
  Map cryptosVal;
  Map data;

  @override
  void initState() {
    super.initState();
    getAllCrypto();
  }

  Future<int> getDataCrypto(String coin, String currency) async {
    CryptoPrice cp = CryptoPrice();
    data = await cp.getCryptoPrice(coin, currency);
    currencyPrice = data["rate"].toInt();

    return currencyPrice;
  }

  void getAllCrypto() async {
    Map<String, int> cryptoValues = {};

    try {
      for (String crypto in cryptoList) {
        int cryptoVal = await getDataCrypto(crypto, selectedCurrency);
        cryptoValues.putIfAbsent(crypto, () => cryptoVal);
      }

      setState(() {
        cryptosVal = cryptoValues;
        isWaiting = false;
      });
    } catch (error) {
      print(error);
    }
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CryptoCard(
                  cryptoCurrency: 'BTC',
                  value: isWaiting ? 0 : cryptosVal['BTC'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  cryptoCurrency: 'ETH',
                  value: isWaiting ? 0 : cryptosVal['ETH'],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  cryptoCurrency: 'LTC',
                  value: isWaiting ? 0 : cryptosVal['LTC'],
                  selectedCurrency: selectedCurrency,
                )
              ]),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton<String>(
              value: selectedCurrency,
              items: getDropdownItems(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                  isWaiting = true;
                  getAllCrypto();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});

  final int value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
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
