import 'dart:convert';
import 'package:http/http.dart' as http;
import '../coin_data.dart';

const apiKey = '6FEBF5AE-0CB4-444C-904B-564BDC624D18';
const coinIoURL = 'https://rest.coinapi.io';
const coinIoPath = 'v1/exchangerate';

class NetworkHelper {
  Future<List<String>> getDataFor({String currency}) async {
    http.Client client = new http.Client();
    List<http.Response> responses = await Future.wait(
      cryptoList.map(
        (cryptoCurrency) => client.get(
          '$coinIoURL/$coinIoPath/$cryptoCurrency/$currency?apikey=$apiKey',
        ),
      ),
    );

    return responses.map(
      (response) {
        var json = jsonDecode(response.body);
        var rate = json['rate'];
        return rate.toStringAsFixed(2);
      },
    ).toList();
  }
}
