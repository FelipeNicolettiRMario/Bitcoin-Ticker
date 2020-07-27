import 'network.dart';

class CryptoPrice {
  String baseUri = "https://rest.coinapi.io/v1/exchangerate";
  String token = "7300112B-BAE2-4DE5-AF93-A5EBEFAAD5C8";

  Future getCryptoPrice(String coin, String currency) async {
    String formatedString =
        baseUri + '/$coin' + '/$currency' + '?apiKey=$token';

    NetworkHelper networkHelper = NetworkHelper(formatedString);

    var fetchResult = await networkHelper.getData();

    return fetchResult;
  }
}
