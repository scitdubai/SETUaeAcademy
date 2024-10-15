import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:set_academy/model/appversionmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ignore: camel_case_types
class AppVersion {
  bool status = false;

  Future<AppVersionModel?> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);
    final long = prefs.get('long');

    print(long);
    print('long');
    print(long);

    String myUrl = "https://set-institute.net/api/latest_version";
    http.Response response = await http.get(Uri.parse(myUrl));
    print(myUrl);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        AppVersionModel user;
        if (Platform.isAndroid) {
          // Android-specific code
          user = AppVersionModel.fromJson(jsonDecode(response.body)['Android']);
        } else if (Platform.isIOS) {
          // iOS-specific code
          user = AppVersionModel.fromJson(jsonDecode(response.body)['IOS']);
        } else {
          user = AppVersionModel.fromJson(jsonDecode(response.body)['Android']);
        }

        return user;
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
