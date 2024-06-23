import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiAcceptence {
    Future<String?> getacceptance() async {
    String myUrl = "https://set-institute.net/api/upload-ios";
    print(myUrl);
    http.Response response = await http.get(Uri.parse(myUrl) );
    if (response.statusCode == 200) {
      print(response.body);
      try {
        
        return response.body;
      } catch (error) {
        print(error);

        return null;
      }
    } else {
      return null;
      // throw "Error While getting Properties";
    }
  }
}