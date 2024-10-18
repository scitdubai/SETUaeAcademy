
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Utils/general_URL.dart';
import '../model/lessons_model.dart';

// ignore: camel_case_types
class get_lessons {
  bool status = false;

  Future<List<new_lessons_model>?> lessons(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);
    final long = prefs.get('long');



    String myUrl = "$serverUrl/lessons?chapter_id=${id}";
    http.Response response = await http.get(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${api_token.toString()}',
      'lang': long.toString()
    });

    if (response.statusCode == 200) {
      List body = jsonDecode(response.body);
      try {
        List<new_lessons_model> orders = body
            .map(
              (dynamic item) => new_lessons_model.fromJson(item),
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
