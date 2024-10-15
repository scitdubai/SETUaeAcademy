
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:set_academy/auth/log_in.dart';
import 'package:set_academy/screen/video/providerfordonaload.dart';
import 'package:set_academy/screen/welcome.dart';
import 'locale/locale_Cont.dart';
import 'locale/locale.dart';
import 'package:provider/provider.dart';

void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DownloadProvider(),
      child: MyApp(),
    ),
  );
}
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
const appfont="Stc";
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(MyLocaleController());
    return GetMaterialApp(
      translations: MyLocale(),
      theme: ThemeData(
        fontFamily: appfont,
      ),
      debugShowCheckedModeBanner: false,
      home: WalkThroughScreen(),
      routes: {
        'login': ((context) => login()),
      },
    );
  }
}
