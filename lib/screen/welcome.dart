import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:set_academy/Utils/appVersion.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locale/locale_Cont.dart';
import '../model/WalkThroughModel.dart';
import 'my_courses/my_courses_screen_firstpage.dart';
import '../controls/user_control.dart';
import '../controls/appversion.dart';
import 'package:set_academy/Utils/apiacceptence.dart';
import 'package:set_academy/screen/EndVersion.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

// تحسين الكود والتصميم بالكامل
class WalkThroughScreenState extends State<WalkThroughScreen> {
  late String deviceToken;
  MyLocaleController controller = Get.find();
  PageController pageController = PageController();
  AppVersion _appVersion = AppVersion();
  User_Control _user_control = User_Control();
  ApiAcceptence _apiAcceptence = ApiAcceptence();
  bool isApiAcceptanceInitialized = false;
  bool isloading = false;
  int currentPage = 0;

  List<WalkThroughModel> walkThroughClass = [
    WalkThroughModel(
      name: 'Welcome to Set Academy',
      text: "Your journey to knowledge starts here.",
      img:  'assets/images/welcome/welcome.png',
    ),
    WalkThroughModel(
      name: 'Learn with Experts',
      text: "Gain valuable insights from industry leaders.",
      img: 'assets/images/welcome/setnewlogo.jpg',
    ),
    WalkThroughModel(
      name: 'Achieve Your Goals',
      text: "Start learning and achieve your professional dreams.",
      img: 'assets/images/welcome/set_3.png',
    )
  ];

  Future<void> getToken() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceToken = apiacceptencevariable == "1"
            ? "${androidInfo.androidId}${androidInfo.device}${androidInfo.manufacturer}${androidInfo.model}"
            : "${androidInfo.device}${androidInfo.manufacturer}${androidInfo.model}";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceToken = "${iosInfo.identifierForVendor}${iosInfo.model}";
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  Future<void> check() async {
    setState(() => isloading = true);
    try {
      await getToken();
      final value = await _appVersion.getAppVersion();
      if (value?.version != app_veriosn) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EndVersion(url: value?.url ?? "")),
          (route) => false,
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        final tokenUser = prefs.getString('api_token');
        final tokenPhone = prefs.getString('phone');
        final tokenPassword = prefs.getString('password');

        if (tokenUser != null) {
          final isLoggedIn = await _user_control.checklogin(
            context,
            tokenPhone ?? '',
            tokenPassword ?? '',
            deviceToken,
          );
          if (isLoggedIn) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => myCourses()), (route) => false);
          } else {
            Navigator.of(context).pushReplacementNamed('login');
          }
        } else {
          Navigator.of(context).pushReplacementNamed('login');
        }
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Check your internet connection!"),
          actions: [
            TextButton(
              child: Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop();
                check();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(() => isloading = false);
    }
  }

  Future<void> _saveLanguagePreference(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('long', lang);
  }

  Future<void> getLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('long');
    if (lang == null) {
      controller.changeLang('en');
      await _saveLanguagePreference('en');
    } else {
      controller.changeLang(lang);
    }
  }

  @override
  void initState() {
    super.initState();
    _apiAcceptence.getacceptance().then((value) {
      setState(() {
        apiacceptencevariable = value.toString();
        isApiAcceptanceInitialized = true;
      });
    });
    getLanguagePreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6200EE),
              Color(0xFF03DAC6),
            ],
          ),
        ),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: walkThroughClass.length,
              controller: pageController,
              itemBuilder: (context, i) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      child: Image.asset(
                        walkThroughClass[i].img.toString(),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width-50,
                        height: MediaQuery.of(context).size.height-400,
                      ),
                    ),
                    Positioned(
                      bottom: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            walkThroughClass[i].name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            walkThroughClass[i].text!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (int i) {
                setState(() {
                  currentPage = i;
                });
              },
            ),
            Positioned(
              bottom: 40,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (currentPage >= 2) {
                    check();
                  } else {
                    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Icon(Icons.arrow_forward, color: Color(0xFF6200EE)),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: isApiAcceptanceInitialized ? check : null,
                child: !isloading
                    ? Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
