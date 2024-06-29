
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:set_academy/auth/log_in.dart';
import 'package:set_academy/screen/welcome.dart';
import 'logale/locale_Cont.dart';
import 'logale/logale.dart';


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      translations: MyLocale(),
      theme: ThemeData(
        fontFamily: 'Cobe',
      ),
      debugShowCheckedModeBanner: false,
      home: WalkThroughScreen(),
      routes: {
        'login': ((context) => login()),
      },
    );
  }
}
