import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class API {
  String key = "AIzaSyBqxK2OtaY7zB-vFUcaeRCefnu83daSbm0";
  var data;

  API();

  Future<http.Response> getBookByIsbn(int isbn) {
    data = http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:' +
          isbn.toString() +
          '&key=' +
          key),
      //'https://tanguy.ozano.ovh/Inno-v-Anglais/public/api/mots'),
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );
    return data;
  }

  Future<dynamic> convertJsonToList() async {
    var data = convert.jsonDecode((await getBookByIsbn(9780613206334)).body);
    return data['items']['id'];
  }

  Future<String> getImage(int isbn) async {
    var maData = convert.jsonDecode(data.body);
    return data['items'][0]['volumeInfo']['imageLinks']['thumbnail'];
  }

  Future<String> getTitle() async {
    var maData = convert.jsonDecode(data.body);
    return data['items'][0]['volumeInfo']['title'];
  }
}
