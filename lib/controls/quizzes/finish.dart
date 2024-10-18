
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../Utils/general_URL.dart';
import '../../model/quizzes_model.dart';

// ignore: camel_case_types
class finish_quizzes {
  bool status = false;

  Future<List<quizzes_model>?> quizzes(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);


    String myUrl = "$serverUrl/quizzes?chapter_id=${id}";
    http.Response response = await http.get(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${api_token.toString()}',
      // 'long': 'ar'
    });
    if (response.statusCode == 200) {
      List body = jsonDecode(response.body);
      try {
        List<quizzes_model> orders = body
            .map(
              (dynamic item) => quizzes_model.fromJson(item),
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

  Future quiz(String id, List<dynamic> answers) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);
    final long = prefs.get('long');


    String myUrl = "$serverUrl/quizzes/${id}/finish";
    http.Response response = await http.post(
      Uri.parse(myUrl),
      body: {
        'answers': answers.toString(),
      },
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${api_token.toString()}',
        'long': long.toString()
      },
    );
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (error) {
        print(error);

        return null;
      }
    } else {
      print(response.body);
      // throw "Error While getting Properties";
    }
  }
}
