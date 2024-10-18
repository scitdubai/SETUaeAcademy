import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:http/http.dart' as http;
import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/general_URL.dart';

// ignore: camel_case_types
class SendCodeToEmail {
  Future sendcodetoemail(String email, context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);

    String myUrl = "$serverUrl/send-code";
    http.Response response = await http.post(Uri.parse(myUrl), body: {
      'phone': email
    });

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

  Future checkcodetoemail1(String email,String code, context) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);

    String myUrl = "$serverUrl/verify-code";
    http.Response response = await http.post(Uri.parse(myUrl), body: {
      'phone': email,
      'code':code
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
     return false;
    }
  }
}
