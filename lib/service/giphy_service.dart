import 'dart:convert';

import 'package:http/http.dart' as http;

String trending() =>
    "https://api.giphy.com/v1/gifs/trending?api_key=7XXK2lMmx1SwyOpOFmz0uapCBGbL1A2a&limit=10&rating=G";

String search(String searchValue, {int offset: 0}) =>
    "https://api.giphy.com/v1/gifs/search?api_key=7XXK2lMmx1SwyOpOFmz0uapCBGbL1A2a&q=$searchValue&limit=19&offset=$offset&rating=G&lang=en";

class GiphyService {
  Future<Map> getGiphys(String url) async {
    print(url);
    http.Response response = await (http.get(url));
    return json.decode(response.body);
  }
}
