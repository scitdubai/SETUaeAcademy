import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/Utils/imageURL.dart';
import 'package:set_academy/locale/locale_Cont.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Color.dart';
import '../controls/user_control.dart';
import '../screen/courses_screen_category.dart';
import 'sign_up.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

bool isbuttonpresses = false;

class _loginState extends State<login> {
  TextEditingController PhoneController = TextEditingController();
  TextEditingController PassController = TextEditingController();
  bool _isHiddenPassword = true;

  User_Control _user_control = User_Control();
  MyLocaleController controller = Get.find();

  var deviceToken;
  
  gettoken() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceToken = apiacceptencevariable.toString() == "1"
            ? (androidInfo.androidId +
                androidInfo.device +
                androidInfo.manufacturer +
                androidInfo.model)
            : (androidInfo.device +
                androidInfo.manufacturer +
                androidInfo.model);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceToken = iosInfo.identifierForVendor + iosInfo.model;
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  @override
  void initState() {
    isbuttonpresses = false;
    get_long();
    gettoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hi = MediaQuery.of(context).size.height;
    double wi = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: hi,
          width: wi,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6200EE),  // لون رئيسي للبنفسجي
                Color(0xFF03DAC6),  // لون ثانوي للأزرق السماوي
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: hi * 0.05),
                Center(
                  child: Image.asset(logo,
                    height: hi * 0.3,
                  ),
                ),
                SizedBox(height: hi * 0.05),
                Text(
                  'LOG IN'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: hi * 0.03),
                formField(PhoneController, 'Phone'.tr, TextInputType.phone, Icons.phone),
                SizedBox(height: hi * 0.03),
                formField(PassController, 'Password'.tr, TextInputType.visiblePassword, Icons.lock),
                SizedBox(height: hi * 0.05),
                !isbuttonpresses
                    ? loginButton('LOG IN'.tr)
                    : Center(child: CircularProgressIndicator(color: Colors.white)),
                SizedBox(height: hi * 0.05),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                            return Courses(asAGuest: true);
                          }));
                        },
                        child: Text(
                          'Continue as Guest'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                            return sgin_up();
                          }));
                        },
                        child: Text(
                          'Don\'t have an account? Sign Up'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(TextEditingController controller, String hintText, TextInputType inputType, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: inputType == TextInputType.visiblePassword ? _isHiddenPassword : false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: inputType == TextInputType.visiblePassword
            ? IconButton(
                icon: Icon(
                  _isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isHiddenPassword = !_isHiddenPassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget loginButton(String text) {
    return Center(
      child: ElevatedButton(
        onPressed: () => loginUser(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF6200EE),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  get_long() async {
    final prefs = await SharedPreferences.getInstance();
    final long = prefs.get('long');
    if (long == null) {
      controller.changeLang('en');
      _save('en');
    } else {
      controller.changeLang(long.toString());
    }
  }

  void loginUser() async {
    String phone = PhoneController.text.trim();
    String password = PassController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(phone.isEmpty ? 'Phone is required' : 'Password is required'.tr),
        backgroundColor: Colors.red,
      ));
    } else {
      setState(() {
        isbuttonpresses = true;
      });
      _user_control.login(context, phone, password, deviceToken).whenComplete(() {
        setState(() {
          isbuttonpresses = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isbuttonpresses = false;
        });
      });
    }
  }

  _save(String long) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('long', long);
  }
}
