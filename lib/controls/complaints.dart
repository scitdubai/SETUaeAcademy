import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import '../Utils/general_URL.dart';
import '../model/my_coursee_model.dart';

// ignore: camel_case_types
class complaints {
  Future add_complaints(String message, context) async {

    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    final api_token = prefs.get(key);

    String myUrl = "$serverUrl/complaints";
    http.Response response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${api_token.toString()}',
    }, body: {
      'message': message
    });
  print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
     
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Done!'.tr,
            message: 'Complaint sent successfully'.tr,
            contentType: ContentType.success,
          ),
        ));
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Please try again later'.tr,
      ).show();
    }
  }
}
