

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../Utils/general_URL.dart';
import '../model/my_coursee_model.dart';

// ignore: camel_case_types
class get_my_courses {
  bool status = false;

  Future<List<my_coursee_model>?> my_courses() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);
    final long = prefs.get('long');


    String myUrl = "$serverUrl/my_courses";
    http.Response response = await http.get(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${api_token.toString()}',
      'lang': long.toString()
    });
   print(response.body);
    if (response.statusCode == 200) {
      List body = jsonDecode(response.body);
      try {
        List<my_coursee_model> orders = body
            .map(
              (dynamic item) => my_coursee_model.fromJson(item),
            )
            .toList();
        return orders;
      } catch (error) {
        print(error);

        return null;
      }
    } else {
      // throw "Error While getting Properties";
    }
  }
}
