import 'dart:convert';

import 'package:set_academy/Utils/general_URL.dart';
import 'package:http/http.dart' as http;

class ApiAcceptence {
    Future<String?> getacceptance() async {
    String myUrl = "$serverUrl/upload-ios";
    http.Response response = await http.get(Uri.parse(myUrl) );
    if (response.statusCode == 200) {
      try {
        return response.body;
      } catch (error) {

        return null;
      }
    } else {
      return null;
      // throw "Error While getting Properties";
    }
  }
}