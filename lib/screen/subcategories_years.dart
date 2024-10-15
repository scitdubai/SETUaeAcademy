import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/Utils/imageURL.dart';
import 'package:set_academy/main.dart';

import '../Utils/Color.dart';
import '../controls/get_control.dart';
import '../model/categories_model.dart';
import '../model/subcategories.dart';
import 'courses_subjects.dart';

class subcategories extends StatefulWidget {
  final bool asAGuest;
  categories_model Cat;
  subcategories({Key? key, required this.Cat, required this.asAGuest}) : super(key: key);

  @override
  State<subcategories> createState() => _subcategoriesState();
}

class _subcategoriesState extends State<subcategories> {
  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  get_Control _get_control = get_Control();
  List<subcategories_model> _subcategories = [];

  getCategories() {
    _get_control
        .get_subcategories(widget.Cat.id.toString())
        .then((value) => setState(() {
              _subcategories = value!;
              isloading = false;
            }));
  }

  bool isloading = true;

  @override
  void initState() {
    getCategories();
    // secure();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hi = MediaQuery.of(context).size.height;
    double wi = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ColorfulSafeArea(
        color: Colors.black,
        child: Container(
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3),
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
                      InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onTap: (() {
                          Navigator.pop(context);
                        }),
                      ),
                      Text(
                        widget.Cat.name.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: appfont,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 130,
                        child: Image.asset(logo)),
                    ],
                  ),
                ),
                // SizedBox(
                //         height: 20,
                //       ),
                // SizedBox(
                //   height: hi / 6,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                    
                      
                //       SizedBox(
                //         width: 50,
                //       ),
                //     ],
                //   ),
                // ),
                
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.all(15),
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
                            itemCount: _subcategories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: (1.2), crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return items(_subcategories[index],widget.asAGuest);
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

  Widget items(subcategories_model subCat,bool asAGuest) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return chapters(
            sub: subCat, asAGuest: widget.asAGuest,
          );
        }));
      },
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              subCat.image.toString(),
              height: 100,
            ),
            Text(
              subCat.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: appfont, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
