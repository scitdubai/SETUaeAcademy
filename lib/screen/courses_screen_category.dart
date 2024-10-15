import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/auth/log_in.dart';
import 'package:set_academy/main.dart';
import 'package:set_academy/model/categories_model.dart';
import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
import 'package:set_academy/screen/subcategories_years.dart';

import '../Utils/Color.dart';
import '../Utils/imageURL.dart';
import '../controls/get_control.dart';

class Courses extends StatefulWidget {
  final bool asAGuest;
  const Courses({Key? key, required this.asAGuest}) : super(key: key);

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  bool isloading = true;
  get_Control _get_control = get_Control();
  List<categories_model> _categories = [];

  getCategories() {
    _get_control.get_categories().then((value) => setState(() {
          _categories = value!;
          isloading = false;
        }));
  }

  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    getCategories();
    // secure();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ColorfulSafeArea(
        color: Colors.black,
        child: Container(
          color: Colors.red,
          child: SafeArea(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(Colorbutton),
                  Color(0xFF9573ec),
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: hi / 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !widget.asAGuest?
                      IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return myCourses();
                            }), (route) => false);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          )):MaterialButton(
                            onPressed: () {
                                Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return login();
                            }), (route) => false);
                            },
                            child: Text('LOG IN'.tr,style: TextStyle(color: Colors.white),),
                          ),
                      Image.asset(logo),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: wi,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50))),
                    child: isloading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Color(Colorbutton),
                          ))
                        : GridView.builder(
                            itemCount: _categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: (1.2), crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return items(_categories[index],widget.asAGuest);
                            },
                          ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget items(categories_model categorie,bool asAGuest) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return subcategories(
            Cat: categorie, asAGuest: widget.asAGuest,
          );
        }));
      },
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              categorie.image.toString(),
              height: 100,
            ),
            Text(
              categorie.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: appfont, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
