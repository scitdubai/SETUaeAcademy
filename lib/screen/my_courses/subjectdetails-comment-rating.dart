import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' ;
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/auth/sign_up.dart';
import 'package:set_academy/controls/comments_control.dart';
import 'package:set_academy/main.dart';
import 'package:set_academy/model/comment_model.dart';
import 'package:set_academy/model/review_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Color.dart';
import '../../controls/get_control.dart';
import '../../controls/requests_courses.dart';
import '../../controls/review_Control.dart';
import '../../model/chapters_model.dart';
import '../../model/my_coursee_model.dart';
import '../../model/techersmodel.dart';
import '../Supject-session-file-exam.dart';
import 'package:image_picker/image_picker.dart';

class subjectdetails extends StatefulWidget {
  my_coursee_model my_coursee;
  bool? show;
  subjectdetails({Key? key, required this.my_coursee, required this.show})
      : super(key: key);

  @override
  State<subjectdetails> createState() => _SearchState();
}

OtpFieldController otpController = OtpFieldController();
bool isLoading = false;

bool isLoadingchapters = false;

class _SearchState extends State<subjectdetails>
    with SingleTickerProviderStateMixin {
  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  TextEditingController comments_Cont = TextEditingController();
  TextEditingController review_Cont = TextEditingController();

  comments_control _comments = comments_control();

  XFile? pickedFile;
  File? imageFile;
  var token_User;
  check() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'api_token';
    token_User = prefs.get(key);
  }

  TabController? _tabController;
  requests_courses _requests_courses = requests_courses();
  TextEditingController Code_Cont = TextEditingController();
  get_Control controller = get_Control();
  review_Control _review_control = review_Control();
  List<techers_model> teachers = [];
  List<courses_model> chapters = [];
  List<comment_model> comments = [];
  List<review_model> reviews = [];
  int rate = 3;
  var transformation;
  get_comments() async {
  try {
    var value = await controller.get_comments(widget.my_coursee.id);
    setState(() {
      comments = value!;
      isLoading = true;
    });
  } catch (error) {
    showError('Failed to load comments');
  }
}

get_reviews() async {
  try {
    var value = await controller.get_reviews(widget.my_coursee.id);
    setState(() {
      reviews = value!;
      isLoading = true;
    });
  } catch (error) {
    showError('Failed to load reviews');
  }
}

get_chapters() async {
  try {
    var value = await controller.get_chapter(widget.my_coursee.id);
    setState(() {
      chapters = value!;
      isLoading = true;
    });
  } catch (error) {
    showError('Failed to load chapters');
  }
}

get_teachers() async {
  try {
    var value = await controller.get_techers(widget.my_coursee.id);
    setState(() {
      teachers = value!;
      isLoadingchapters = true;
    });
  } catch (error) {
    showError('Failed to load teachers');
  }
}

// Helper function to show error message
showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

@override
void initState() {
  super.initState();
  print(widget.my_coursee.request.toString());

  if (widget.my_coursee.request.toString() != "null") {
    print("done");
    setState(() {
      widget.show = false;
    });
    print(widget.show);
  }
  
  print(widget.show);
  
  check();
  get_comments();
  get_reviews();
  secure();
  get_chapters();
  get_teachers();

  _tabController = TabController(length: 4, vsync: this);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Colorbutton),
        title: Text(widget.my_coursee.title.toString())
        ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage('${widget.my_coursee.image}'))),
                    ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Flexible(
                  //     child: Text(
                  //   widget.my_coursee.title.toString(),
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontFamily: appfont,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // )),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // المسافات بين الصفين
                children: [
                  // الجزء الخاص بالساعات
                  Row(
                    children: [
                      Text(
                        'hour'.tr,
                        style: TextStyle(
                          fontSize: 16, // تغيير حجم الخط
                          fontWeight: FontWeight.bold, // جعل النص عريضًا
                          color: Colors.black87, // لون النص
                        ),
                      ),
                      SizedBox(width: 5), // تباعد بين النص والرقم
                      Text(
                        "${widget.my_coursee.hours.toString()}",
                        style: TextStyle(
                          fontFamily: appfont,
                          fontSize: 16, // حجم الخط
                          color: Colors.black, // لون النص
                        ),
                      ),
                      SizedBox(width: 5), // تباعد بين الرقم والأيقونة
                      Icon(
                        Icons.watch_later_outlined,
                        color: Color(Colorbutton),
                        size: 18, // حجم الأيقونة أكبر قليلاً
                      ),
                    ],
                  ),
                  

                  // الجزء الخاص بالفصول
                  Row(
                    children: [
                      Text(
                        'Chapter'.tr,
                        style: TextStyle(
                          fontSize: 16, // تغيير حجم الخط
                          fontWeight: FontWeight.bold, // جعل النص عريضًا
                          color: Colors.black87, // لون النص
                        ),
                      ),
                      SizedBox(width: 5), // تباعد بين النص والرقم
                      Text(
                        "${widget.my_coursee.chapters_count.toString()}",
                        style: TextStyle(
                          fontFamily: appfont,
                          fontSize: 16, // حجم الخط
                          color: Colors.black, // لون النص
                        ),
                      ),
                      SizedBox(width: 5), // تباعد بين الرقم والأيقونة
                      Icon(
                        Icons.book_sharp,
                        color: Color(Colorbutton),
                        size: 18, // حجم الأيقونة أكبر قليلاً
                      ),
                    ],
                  ),
                ],
             ),

            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Color(Colorbutton),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                height: 35,
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 12),
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "Comments".tr,
                    ),
                    Tab(
                      text: "Ratings".tr,
                    ),
                    Tab(
                      text: "Chapters".tr,
                    ),
                    Tab(
                      text: "Teachers".tr,
                    ),
                  ],
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  comments.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              comment(),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text('There are no data'.tr),
                            widget.show == true
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          actions: [
                                                            contact_us(context)
                                                          ],
                                                        ));
                                          },
                                          child: Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  // side: BorderSide(width: 1.0, color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              minimumSize: const Size(50, 50),
                                              backgroundColor: Color(Colorbutton))),
                                    ],
                                  )
                          ],
                        )),
                  reviews.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              review(),
                              widget.show == true
                                  ? SizedBox()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      AlertDialog(
                                                        actions: [
                                                          add_review(context)
                                                        ],
                                                      ));
                                            },
                                            child: Icon(Icons.edit),
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    // side: BorderSide(width: 1.0, color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                minimumSize: const Size(50, 50),
                                                backgroundColor: Color(Colorbutton))),
                                      ],
                                    ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Center(child: Text('There are no data'.tr)),
                            widget.show == true
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                          actions: [
                                                            add_review(context)
                                                          ],
                                                        ));
                                          },
                                          child: Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  // side: BorderSide(width: 1.0, color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              minimumSize: const Size(50, 50),
                                              backgroundColor: Color(Colorbutton))),
                                    ],
                                  ),
                          ],
                        ),
                  chapters.isNotEmpty
                      ? chapter()
                      : Center(child: Text('There are no data'.tr)),
                  teachers.isNotEmpty
                      ? teacher()
                      : Center(
                          child: Text(
                          'There are no data'.tr,
                        )),
                ],
              ),
            ),
            widget.show == true
                ? 
                 apiacceptencevariable.toString()!="0"?
                InkWell(
                    onTap: () {
                      token_User == null
                          ? {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.bottomSlide,
                                title: 'You do not have an account'.tr,
                                desc: 'Please create an account'.tr,
                                btnOkOnPress: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return sgin_up();
                                    },
                                  ), (route) => false);
                                },
                              ).show()
                            }
                          : {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return SingleChildScrollView(
                                      // controller:
                                      //     ModalScrollController.of(context),
                                      child: Container(
                                          height: MediaQuery.of(context).size.height / 1.5,
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15),
                                              Container(
                                                width: 55,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50), color: Colors.black54),
                                              ),
                                              SizedBox(height: 15),
                                              Text(apiacceptencevariable.toString()!="0"?'Please select a payment process'.tr:"enter Coupon code"),
                                              apiacceptencevariable.toString()!="0"?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      
                                                      Radio(
                                                        activeColor: Color(Colorbutton),
                                                        value: 'Bank',
                                                        groupValue: transformation,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            transformation = value;
                                                          });
                                                        },
                                                      ),
                                                      Text('Bank'.tr),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        activeColor: Color(Colorbutton),
                                                        value: 'Coupon',
                                                        groupValue: transformation,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            transformation = value;
                                                          });
                                                        },
                                                      ),
                                                      Text('Coupon'.tr),
                                                    ],
                                                  ),
                                                ],
                                              ):SizedBox(),
                                              SizedBox(height: 25),
                                              transformation == 'Bank'
                                                  ? ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        _getFromcamera();
                                                      },
                                                      child: Text(
                                                        'Add image'.tr,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15)),
                                                          minimumSize: const Size(250, 50),
                                                          backgroundColor: Color(Colorbutton)),
                                                    )
                                                  : Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: OTPTextField(
                                                          controller: otpController,
                                                          length: 6,
                                                          width: MediaQuery.of(context).size.width,
                                                          textFieldAlignment: MainAxisAlignment.spaceAround,
                                                          fieldWidth: 45,
                                                          fieldStyle: FieldStyle.box,
                                                          outlineBorderRadius: 15,
                                                          style: TextStyle(fontSize: 17),
                                                          onChanged: (pin) {
                                                            print("Changed: " + pin);
                                                          },
                                                          onCompleted: (pin) {
                                                            Code_Cont.text = pin.toString();
                                                          }),
                                                    ),
                                              SizedBox(height: 50),
                                              
                                            
                                              ElevatedButton(
                                                onPressed: () {
                                                  // التأكد من أن المستخدم قد اختار إما "Bank" أو "Coupon"
                                                  if (transformation == null || transformation!.isEmpty) {
                                                    // عرض Dialog تحذيري
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Error'.tr),
                                                          content: Text('Please select a payment process'.tr),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    // التحقق من الصورة إذا كانت "Bank"
                                                    if (transformation == 'Bank' && imageFile == null) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Error'.tr),
                                                            content: Text('Please upload an image for the bank process'.tr),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    // التحقق من الكوبون إذا كانت "Coupon"
                                                    else if (transformation == 'Coupon' && Code_Cont.text.isEmpty) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Error'.tr),
                                                            content: Text('Please enter the coupon code'.tr),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('OK'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }
                                                    // إذا تم الاختيار بشكل صحيح ومر الشروط
                                                    else {
                                                      _requests_courses
                                                          .send_code(
                                                              widget.my_coursee.id.toString(),
                                                              Code_Cont.text.toString(),
                                                              context)
                                                          .whenComplete(() {
                                                        Future.delayed(Duration(seconds: 5), () {
                                                          Navigator.pushAndRemoveUntil(context,
                                                              MaterialPageRoute(builder: (context) {
                                                            return myCourses();
                                                          }), (route) => false);
                                                        });
                                                      });
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  'Verification'.tr,
                                                  style: TextStyle(
                                                      fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(15)),
                                                    minimumSize: const Size(150, 50),
                                                    backgroundColor: Color(Colorbutton)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        );
                                }),
                              ),
                             
                            };
                     
                    },
                    child: widget.my_coursee.course_student.toString() == "null"
                        ? widget.my_coursee.request.toString() == "null"
                            ? Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Course request".tr,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    apiacceptencevariable.toString()!="0"?
                                    Row(
                                      children: [
                                        Text(
                                         " ${widget.my_coursee.price}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        
                                        Text(
                                          
                                          " sp".tr
                                          ,

                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ):SizedBox(),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Color(Colorbutton),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 50,
                                width: double.infinity,
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(5),
                              )
                            : SizedBox()
                        : SizedBox(),
                  ): ElevatedButton(
                                                 style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15)),
                                                          minimumSize: const Size(250, 50),
                                                          backgroundColor: Color(Colorbutton)),
                                                onPressed: () {
                                                  _requests_courses.send_code(widget.my_coursee.id.toString(), "code", context).whenComplete(() {
                                                        Future.delayed(Duration(seconds: 5), () {
                                                          Navigator.pushAndRemoveUntil(context,
                                                              MaterialPageRoute(builder: (context) {
                                                            return myCourses();
                                                          }), (route) => false);
                                                        });
                                                      });
                                                }, child: Text("Add Course"))
                : SizedBox(),
                                             
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget comment() {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(45)),
              color: Colors.white,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      comments[index].name_user.toString(),
                    ),
                    subtitle: Text(comments[index].comment.toString()),
                  ));
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            actions: [contact_us(context)],
                          ));
                },
                child: Icon(Icons.edit),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        // side: BorderSide(width: 1.0, color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    minimumSize: const Size(50, 50),
                    backgroundColor: Color(Colorbutton))),
          ],
        )
      ],
    );
  }

  Center teacher() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 545,
        child: ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                title: Text(
                  teachers[index].first_name,
                  textAlign: TextAlign.right,
                ),
                trailing: CircleAvatar(
                  backgroundImage: NetworkImage(teachers[index].image),
                ),
              ));
            }),
      ),
    );
  }

  Center chapter() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 545,
        child: ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Content(
                              courses: chapters[index], show: widget.show!);
                        }));
                      },
                      title: Text(
                        chapters[index].title.toString(),
                        textAlign: TextAlign.right,
                      ),
                      trailing: chapters[index].image == null
                          ? SizedBox()
                          : Image.network(
                              imageUrl + chapters[index].image,
                              width: 50,
                            )));
            }),
      ),
    );
  }

  Container add_review(context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextFormField(
            maxLines: 8,
            keyboardType: TextInputType.text,
            cursorColor: Colors.black,
            controller: review_Cont,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xff34196b))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF9C8FB4))),
              hintText: 'Enter the comments'.tr,
              hintStyle:
                  TextStyle(color: Color(0xff8c9289), fontFamily: appfont),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              rate = rating.toInt();
            },
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _review_control
                  .add_review(widget.my_coursee.id.toString(),
                      review_Cont.text.toString(), rate.toString(), context)
                  .whenComplete(() {
                Navigator.of(context, rootNavigator: true).pop();
                review_Cont.text = '';
              });
            },
            child: Text(
              'Send'.tr,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    // side: BorderSide(width: 2.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(90, 50),
                backgroundColor: Color(Colorbutton)),
          )
        ],
      ),
    );
  }

  Container contact_us(context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextFormField(
            maxLines: 8,
            keyboardType: TextInputType.text,
            cursorColor: Colors.black,
            controller: comments_Cont,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xff34196b))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF9C8FB4))),
              hintText: 'Enter the comments'.tr,
              hintStyle:
                  TextStyle(color: Color(0xff8c9289), fontFamily: appfont),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (comments_Cont.text != "") {
                _comments
                    .add_comments(widget.my_coursee.id.toString(),
                        comments_Cont.text.toString(), context)
                    .whenComplete(
                        () => Navigator.of(context, rootNavigator: true).pop());
                comments_Cont.text = '';
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("add comment"),
                    );
                  },
                );
              }
            },
            child: Text(
              'Send'.tr,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    // side: BorderSide(width: 2.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(90, 50),
                backgroundColor: Color(Colorbutton)),
          )
        ],
      ),
    );
  }

  Center review() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(45)),
          color: Colors.white,
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 3,
        child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                title: Text(
                  reviews[index].name_user.toString(),
                ),
                subtitle: Text(
                  reviews[index].message.toString(),
                ),
                trailing: RatingBarIndicator(
                  rating: double.parse("${reviews[index].rate}"),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ));
            }),
      ),
    );
  }

  _getFromcamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      print(imageFile);
      _requests_courses.Send_image(imageFile!, widget.my_coursee.id,
              Code_Cont.text.toString(), context)
          .whenComplete(() {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return myCourses();
            },
          ), (route) => false);
        });
      });
    }
  }
}
