import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

String _url = 'http://dveri-dvernik.ru:65100';
String authorizationHeader = 'Basic ${base64Encode(utf8.encode('admin:admin'))}';

Future getImg(urlImg) async {
  // var url = Uri.parse(urlImg);
  
  final response = await http.get(
    Uri.parse(urlImg),
  );

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return {
      "successful": false
    };
  }
}

Future getCatalog() async {
  var url = Uri.parse('$_url/api/v1/categories/get-categories');
  
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: authorizationHeader,
    }
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return {
      "successful": false
    };
  }
}

Future getProduct() async {
  var url = Uri.parse('$_url/api/v1/product/get-products');

  final response = await http.get(
    url,
    headers: {
      HttpHeaders.authorizationHeader: authorizationHeader,
    }
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return {
      "successful": false
    };
  }
}