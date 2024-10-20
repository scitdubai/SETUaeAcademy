import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/Utils/imageURL.dart';
import 'package:set_academy/controls/get_control.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/Color.dart';
import '../controls/user_control.dart';
import '../model/governorates.dart';
import '../model/specializations.dart';
import '../model/universities.dart';
import 'val.dart';

class sgin_up extends StatefulWidget {
  sgin_up({Key? key}) : super(key: key);

  @override
  State<sgin_up> createState() => _sgin_upState();
}
  bool _isHiddenPassword = true;
String phonecode = "+";
String phonenumber = "+";
String countrycode = "UAE";

class _sgin_upState extends State<sgin_up> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController mnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String year = '1';
  var group;
  bool istrue = false;
  String graduated = '1';
  List<Mgovernorates>? Lgovernorates = [];
  var governorate;

  List<Mspecializations>? Lspecializations = [];
  var specialization;

  List<Muniversities>? Luniversities = [];
  var universitie;

  String? deviceToken;
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
     
        return androidInfo.androidId;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceToken = iosInfo.identifierForVendor + iosInfo.model;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  List<String> Lyear = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  get_Control _get_control = get_Control();

  val _vre = val();
  User_Control _user_control = User_Control();

  getgovernorate() {
    _get_control.get_governorates().then((value) => setState(() {
          if (apiacceptencevariable.toString()=="0"){
            Lgovernorates=[Mgovernorates(id: "1", code: '0000', name: "Abu Dhabi", name_array: "name_array"),
            Mgovernorates(id: "1", code: '0000', name: "Abu Dhabi", name_array: "name_array"),
            Mgovernorates(id: "2", code: '0000', name: "Dubai", name_array: "name_array"),
            Mgovernorates(id: "3", code: '0000', name: "Sharjah", name_array: "name_array"),
            Mgovernorates(id: "4", code: '0000', name: "Ajman", name_array: "name_array"),
            Mgovernorates(id: "5", code: '0000', name: "Fujairah", name_array: "name_array"),
            Mgovernorates(id: "6", code: '0000', name: "Ras Al Khaimah", name_array: "name_array"),
            Mgovernorates(id: "7", code: '0000', name: " Umm Al Quwain", name_array: "name_array")
            ];
          }else{
            Lgovernorates = value!;
          }
          
          
        }));
  }

  getspecialization() {
    _get_control.get_specializations().then((value) => setState(() {
          Lspecializations = value!;
        }));
  }

  getuniversitie() {
    _get_control.get_universities().then((value) => setState(() {
      if (apiacceptencevariable.toString()=="0") {
            Luniversities=[Muniversities(id: "1", code: "0000", name: 'UAEU', name_array: "name_array"),Muniversities(id: "2", code: "0000", name: 'Khalifa University', name_array: "name_array"),Muniversities(id: "3", code: "0000", name: 'American University of Sharjah - AUS', name_array: "name_array")];
          }else{
          Luniversities = value!;
          }
        }));
  }

  @override
  void initState() {
    gettoken();
    getgovernorate();
    getuniversitie();
    getspecialization();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hi = MediaQuery.of(context).size.height;
    double wi = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
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
            height: hi,
            width: wi,
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios,color: Colors.white,))
                      ],
                    ),
                  ),
                  Image.asset(
                    logo,
                    height: 200,
                  ),
                  Row(
                    children: [
                      Text(
                        'Create an Account'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: hi / 50,
                  ),
                  form(fnameController, 'First Name'.tr, TextInputType.name),
                  SizedBox(
                    height: hi / 70,
                  ),
                  form(mnameController, 'Middle Name'.tr, TextInputType.name),
                  SizedBox(
                    height: hi / 70,
                  ),
                  form(lnameController, 'Last Name'.tr, TextInputType.name),
                  SizedBox(
                    height: hi / 70,
                  ),
                  
                  SizedBox(
                    height: hi / 70,
                  ),
                  form(passwordController, 'Password'.tr,
                      TextInputType.visiblePassword),
                  SizedBox(
                    height: hi / 70,
                  ),
                  form(passwordConfController, 'Password confirmation'.tr,
                      TextInputType.visiblePassword),
                  SizedBox(
                    height: hi / 70,
                  ),
                  form(emailController, 'Email'.tr, TextInputType.emailAddress),
                    SizedBox(
                    height: hi / 70,
                  ),
                  form(addressController, 'Address'.tr, TextInputType.name),
                 
                  SizedBox(
                    height: hi / 70,
                  ),

                  Column(
                    children: [
                      // apiacceptencevariable.toString()!="0"?
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(width: 1, color: Color(0xff34196b))),
                        child: DropdownButton<dynamic>(
                          items: Lgovernorates!
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e.name.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Cobe',
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    value: e.id,
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              governorate = newValue;
                            });
                          },
                          isExpanded: true,
                          hint: Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              'Governorate'.tr,
                              style: TextStyle(
                                  fontFamily: 'Cobe',
                                  fontSize: 16,
                                  color: Colors.black45),
                            ),
                          ),
                          value: governorate,
                          icon: Icon(Icons.keyboard_arrow_down_outlined,
                              color: Color(0xff34196b)),
                        ),
                      )
                      // :SizedBox(),
                    ],
                  ),
                 SizedBox(
                    height: hi / 70,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(width: 1, color: Color(0xff34196b))),
                        child: DropdownButton<dynamic>(
                          items: Lspecializations!
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e.name.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Cobe',
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    value: e.id,
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              specialization = newValue;
                            });
                          },
                          isExpanded: true,
                          hint: Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              'Specializations'.tr,
                              style: TextStyle(
                                  fontFamily: 'Cobe',
                                  fontSize: 16,
                                  color: Colors.black45),
                            ),
                          ),
                          value: specialization,
                          icon: Icon(Icons.keyboard_arrow_down_outlined,
                              color: Color(0xff34196b)),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(
                    height: hi / 70,
                  ),
                  Column(
                    children: [
                      // apiacceptencevariable.toString()!="0"?
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(width: 1, color: Color(0xff34196b))),
                        child: DropdownButton<dynamic>(
                          items: Luniversities!
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e.name.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Cobe',
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    value: e.id,
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              universitie = newValue;
                            });
                          },
                          isExpanded: true,
                          hint: Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              'Universities'.tr,
                              style: TextStyle(
                                  fontFamily: 'Cobe',
                                  fontSize: 16,
                                  color: Colors.black45),
                            ),
                          ),
                          value: universitie,
                          icon: Icon(Icons.keyboard_arrow_down_outlined,
                              color: Color(0xff34196b)),
                        ),
                      )
                      // :SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: hi / 70,
                  ),
                  IntlPhoneField(
                    validator: (p0) {
                      if (phonecode == "+") {
                        return "enter mobile number";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    initialCountryCode: 'UAE',
                    onChanged: (phone) {
                      phonenumber = phone.number;
                      countrycode = phone.countryCode;
                      phonecode = (phone.countryCode.toString() +
                          phone.number.substring(1, 10)) as String;
                    
                    },
                  ),
                  SizedBox(
                    height: hi / 70,
                  ),
                  Row(
                    children: [
                      Text(
                        'Are you graduated ?'.tr,
                        style: TextStyle(
                          color: Colors.white,
                            fontFamily: 'Cobe',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  SystemOrExpert(),
                  SizedBox(
                    height: hi / 80,
                  ),
                  group == 'NO'.tr
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1, color: Color(0xff34196b))),
                              child: DropdownButton<dynamic>(
                                items: Lyear.map((e) => DropdownMenuItem(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Cobe',
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      value: e,
                                    )).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    year = newValue;
                                  });
                                },
                                isExpanded: true,
                                hint: Container(
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    'Year'.tr,
                                    style: TextStyle(
                                        fontFamily: 'Cobe',
                                        fontSize: 16,
                                        color: Colors.black45),
                                  ),
                                ),
                                value: year,
                                icon: Icon(Icons.keyboard_arrow_down_outlined,
                                    color: Color(0xff34196b)),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: hi / 80,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Color(Colorbutton),
                        value: istrue,
                        onChanged: (value) {
                          setState(() {
                            istrue = value!;
                          });
                        },
                      ),
                      Text('Do you agree'.tr,style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: () {
                            launcher.launch(
                                "https://set-institute.net/privacy-policy");
                          },
                          child: Text(
                            'Terms and Conditions'.tr,
                            style: TextStyle(
                                color: Color(Colorbutton),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  istrue == true
                      ? ElevatedButton(
                          onPressed: () {
                            if (passwordController.text
                                    .toString()
                                    .trim()
                                    .length <
                                8) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'The password must be at least 8 characters'
                                        .tr),
                                backgroundColor: Colors.red,
                              ));
                            } else if (passwordController.text
                                    .toString()
                                    .trim() !=
                                passwordConfController.text.toString().trim()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('password does not match'.tr),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                            

                              _user_control.register(
                                  fnameController.text,
                                  mnameController.text,
                                  lnameController.text,
                                  phonenumber,
                                  passwordController.text,
                                  emailController.text,
                                  governorate,
                                  addressController.text,
                                  specialization,
                                  universitie.toString(),
                                  graduated.toString(),
                                  year,
                                  deviceToken!,
                                  context);
                            }
                          },
                          child: Text(
                            'Sign Up'.tr,
                            style: TextStyle(
                                fontFamily: 'Cobe',
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.0, color: Colors.black),
                                  borderRadius: BorderRadius.circular(8)),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Color(0xff34196b)))
                      : ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Sign Up'.tr,
                            style: TextStyle(
                                fontFamily: 'Cobe',
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.0, color: Color(0xFF767479)),
                                  borderRadius: BorderRadius.circular(8)),
                              minimumSize: const Size(double.infinity, 50),
                             backgroundColor: Color(0xFF767479))),
                  SizedBox(
                    height: hi / 50,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

Widget form(TextEditingController controller, String hintText, TextInputType inputType,) {
  return TextField(
    controller: controller,
    keyboardType: inputType,
    obscureText: inputType == TextInputType.visiblePassword ? _isHiddenPassword : false,
    style: TextStyle(color: Colors.white), // يمكنك تغيير اللون هنا
    decoration: InputDecoration(
      suffixIcon: inputType == TextInputType.visiblePassword
          ? IconButton(
              icon: Icon(
                _isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isHiddenPassword = !_isHiddenPassword;
                });
              },
            )
          : null,
      filled: true,
      fillColor: Colors.black.withOpacity(0.1), // يمكنك تغيير لون الخلفية هنا
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white), // لون نص التلميح
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  );
}


  Widget SystemOrExpert() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Radio(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.green;
                }),
                value: "YES".tr,
                
                groupValue: group,
                onChanged: (value) {
                  setState(() {
                    group = value.toString();
                    graduated = '1';
                  });
                }),
            SizedBox(
              width: 15,
            ),
            Text(
              'YES'.tr,
              style: TextStyle(
                color: Colors.white,
                  fontFamily: 'Cobe',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.red;
                }),
                value: "NO".tr,
                groupValue: group,
                onChanged: (value) {
                  setState(() {
                    group = value.toString();
                    graduated = '0';
                  });
                }),
            SizedBox(
              width: 15,
            ),
            Text(
              'NO'.tr,
              style: TextStyle(
                color: Colors.white,
                  fontFamily: 'Cobe',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
