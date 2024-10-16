import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:set_academy/controls/my_courses.dart';
import 'package:set_academy/main.dart';
import 'package:set_academy/model/my_coursee_model.dart';
import 'package:set_academy/screen/my_courses/subjectdetails-comment-rating.dart';
import '../../Utils/Color.dart';
import '../courses_screen_category.dart';

class UserCourses extends StatefulWidget {
  @override
  _UserCoursesState createState() => _UserCoursesState();
}

class _UserCoursesState extends State<UserCourses> {
  final get_my_courses _get_my_courses = get_my_courses();
  List<my_coursee_model> List_my_courses = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    secure();
    my_courses();
  }

  // تأمين الشاشة
  Future<void> secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  // جلب الدورات
  Future<void> my_courses() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      List<my_coursee_model>? courses = await _get_my_courses.my_courses();
      if (courses != null) {
        setState(() {
          List_my_courses = courses;
          isLoading = false;
        });
      } else {
        throw Exception('No courses found');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      showError('Failed to load courses. Please try again.');
    }
  }

  // عرض رسالة الخطأ
  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // بناء واجهة المستخدم
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: my_courses, // تم تصحيح استخدام onRefresh
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading courses. Please try again.'),
                        ElevatedButton(
                          onPressed: my_courses,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : List_my_courses.isEmpty
                    ? Center(
                        child: Text(
                          'No courses available.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.all(10),
                              itemCount: List_my_courses.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.1,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                return courseItem(List_my_courses[index]);
                              },
                            ),
                          ),
                          _buildSubscribeButton(),
                        ],
                      ),
      ),
    );
  }

  // بناء واجهة العنصر الخاص بالدورة
  Widget courseItem(my_coursee_model myCourses) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return subjectdetails(
            my_coursee: myCourses,
            show: false,
          );
        }));
      },
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              myCourses.image.toString(),
              height: 100,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            Text(
              myCourses.title.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: appfont, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // بناء زر الاشتراك في الدورات
  Widget _buildSubscribeButton() {
    return Container(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Courses(asAGuest: false);
          }));
        },
        child: Text(
          'Subscribe to a course'.tr,
          style: TextStyle(
              fontSize: 17,
              fontFamily: appfont,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(Colorbutton),
          elevation: 8,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
