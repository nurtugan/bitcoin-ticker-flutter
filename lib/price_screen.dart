import 'dart:io' show Platform;
import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'coin_data.dart';
import 'currency_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  String selectedCurrency = 'AUD';
  String btcCost = '?';
  String ethCost = '?';
  String ltcCost = '?';

  void getCurrencyData() async {
    var rates = await networkHelper.getDataFor(currency: selectedCurrency);
    setState(
      () {
        btcCost = rates[0];
        ethCost = rates[1];
        ltcCost = rates[2];
      },
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownMenuItems = currenciesList.map(
      (currency) {
        return DropdownMenuItem(
          child: Text(currency),
          value: currency,
        );
      },
    ).toList();
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenuItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems =
        currenciesList.map((currency) => Text(currency)).toList();
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getCurrencyData();
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrencyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CurrencyCard(
            cryptoCurrencyName: 'BTC',
            cost: btcCost,
            selectedCurrency: selectedCurrency,
          ),
          CurrencyCard(
            cryptoCurrencyName: 'ETH',
            cost: ethCost,
            selectedCurrency: selectedCurrency,
          ),
          CurrencyCard(
            cryptoCurrencyName: 'LTC',
            cost: ltcCost,
            selectedCurrency: selectedCurrency,
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
