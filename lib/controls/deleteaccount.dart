
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/general_URL.dart';

// ignore: camel_case_types
class DeleteAccout {
  Future delte_account( String password, context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);


    String myUrl = "$serverUrl/user";
    http.Response response = await http.delete(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${api_token.toString()}',
    }, body: {
      'password': password,
    });

    print(api_token);
    print(myUrl);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Done!'.tr,
            message: ' ',
            contentType: ContentType.success,
          ),
        ));
    } else {
      print('else');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Please try again later'.tr,
            message: ' ',
            contentType: ContentType.warning,
          ),
        ));
    }
  }
}
