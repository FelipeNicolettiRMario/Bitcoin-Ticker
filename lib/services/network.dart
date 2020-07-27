import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.uri);

  final String uri;

  Future getData() async {
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      print(response.statusCode);
    }
  }
}
