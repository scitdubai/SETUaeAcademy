import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:set_academy/Utils/general_URL.dart';
import 'package:set_academy/model/lessons_model.dart';
import 'package:set_academy/model/quizzes_model.dart';
import 'package:set_academy/screen/video/chewieVideoPlayer.dart';
import 'package:set_academy/screen/video/filedownloader.dart';
import 'package:set_academy/screen/video/testScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/Color.dart';
import '../Utils/imageURL.dart';
import '../controls/get_control.dart';
import '../controls/lessons.dart';
import '../controls/quizzes/finish.dart';
import '../controls/quizzes/quizzes.dart';
import '../controls/quizzes/start.dart';
import '../model/chapters_model.dart';
import '../model/files_model.dart';
import '../model/my_coursee_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Content extends StatefulWidget {
  courses_model courses;
  bool show;
  Content({Key? key, required this.courses, required this.show})
      : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

int trytofail = 0;
bool _onFinishButtonPresses = false;

class _ContentState extends State<Content> with SingleTickerProviderStateMixin {
  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  TabController? _tabController;
  PageController _pageController = PageController();
  String isloadingBook = '0';
  get_Control _get_control = get_Control();
  get_lessons _get_lessons = get_lessons();
  get_quizzes _get_quizzes = get_quizzes();
  start_quizzes _start_quizzes = start_quizzes();
  finish_quizzes _finish_quizzes = finish_quizzes();
  List<files_model> _files = [];
  List<new_lessons_model> _lessons = [];
  List<files_model> _books = [];
  List<quizzes_model> _quizzes = [];

  List<String> answer = [];
  // List<question_model> _question = [];
  bool isloading1 = true;
  bool isloading2 = true;
  bool isloading3 = true;
  bool isStart = false;
  var _total;
  int numPage = 1;
  getfiles() {
    _get_control
        .get_files(widget.courses.id.toString())
        .then((value) => setState(() {
              _files = value!;
              isloading2 = false;
            }));
  }

  get_quizzess() {
    _get_quizzes
        .quizzes(widget.courses.id.toString())
        .then((value) => setState(() {
              _quizzes = value!;
              isloading3 = false;
            }));
  }

  get_lessonss() {
    _get_lessons
        .lessons(widget.courses.id.toString())
        .then((value) => setState(() {
              _lessons = value!;
              isloading1 = false;
            }));
  }

  var ans;

  @override
  void initState() {
    trytofail = 0;
    _onFinishButtonPresses = false;
    getfiles();
    get_lessonss();
    get_quizzess();
    secure();
    // get_question();
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Colorbutton),
        title: Text(widget.courses.title.toString(),style: TextStyle(fontSize: 14),)
        ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            SizedBox(
              height: 10,
            ),
           
            Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage('${imageUrl + widget.courses.image}'))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 320,
                    child: Text(
                      widget.courses.title.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Cobe',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "Sessions".tr,
                    ),
                    Tab(
                      text: "Files".tr,
                    ),
                    Tab(
                      text: "Exams".tr,
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
                children: [
                  isloading1
                      ? Circular()
                      : _lessons.length == 0
                          ? Center(child: Text('There are no data'.tr))
                          : lessons(),
                  isloading2
                      ? Circular()
                      : _files.length == 0
                          ? Center(child: Text('There are no data'.tr))
                          : files(),
                  isloading3
                      ? Circular()
                      : _quizzes.isEmpty
                          ? Center(child: Text('There are no data'.tr))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'test duration'.tr,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      ' ${_quizzes[0].duration} ',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      'minutes'.tr,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      widget.show
                                          ? {
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title:
                                                        'There is no subscription'
                                                            .tr,
                                                    message:
                                                        'Complaint sent successfully'
                                                            .tr,
                                                    contentType:
                                                        ContentType.warning,
                                                  ),
                                                ))
                                            }
                                          : {
                                              showDialog(
                                                context: context,
                                                builder: (context2) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.blue),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    content: Opacity(
                                                      opacity: 0.6,
                                                      child: Container(
                                                        height: 120,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.info,
                                                              size: 70,
                                                              color: Color(
                                                                  Colorbutton),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  "لا تستطيع التقدم \nلهذا الاختبار الا مرة واحدة",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: 78,
                                                                      child:
                                                                          MaterialButton(
                                                                        color: Colors
                                                                            .green,
                                                                        child: Text(
                                                                            "ok"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context2)
                                                                              .pop();
                                                                          _start_quizzes
                                                                              .start(_quizzes[0].id.toString(), context)
                                                                              .whenComplete(() {
                                                                            setState(() {
                                                                              isStart = _start_quizzes.status;
                                                                              if (isStart) {
                                                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                                                                  return TestScreen(
                                                                                    quizzes: _quizzes,
                                                                                  );
                                                                                }), (route) => false);
                                                                              }
                                                                            });
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Container(
                                                                      width: 78,
                                                                      child:
                                                                          MaterialButton(
                                                                        color: Colors
                                                                            .red,
                                                                        child: Text(
                                                                            "cancel"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            };
                                    },
                                    child: Text(
                                      'Start'.tr,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            // side: BorderSide(width: 1.0, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        minimumSize: const Size(100, 50),
                                        backgroundColor: Colors.green)),
                              ],
                            )
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container lessons() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _lessons.length,
        itemBuilder: (BuildContext context, int index) {
          return item_lessons(_lessons[index]);
        },
      ),
    );
  }

  Center Circular() {
    return Center(
      child: CircularProgressIndicator(
        color: Color(Colorbutton),
      ),
    );
  }

  Container files() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (BuildContext context, int index) {
          return items(_files[index]);
        },
      ),
    );
  }



  Widget items(files_model file) {
    return Card(
      elevation: 8,
      child: ListTile(
        onTap: () {
         
        },
        title: Text(
          file.file_name.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontFamily: 'Cobe', fontWeight: FontWeight.bold),
        ),
        trailing: Container(
            height: 50,
            width: 100,
            child: FileDownloader(
                downloadurl: file.file_url, name: file.file_name)),

        leading: Image.asset(
          logo,
          height: 75,
        ),
       
        //           )
      ),
    );
  }

  Widget item_lessons(new_lessons_model lessons) {
    return Card(
      color: lessons.free ? Colors.white : Colors.purple[100],
      elevation: 8,
      child: ListTile(
        onTap: () {
          lessons.free != true
              ? {
                  (lessons.subscribed.toString() == "true")
                      ? {
                          (lessons.use_resource.toString() == "drive")
                              ? {_launchUrl(lessons.drive_url)}
                              : {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return MyNewVideoPlayer(
                                      url: lessons.video_url,
                                    );
                                  }))
                                }
                        }
                      : {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'There is no subscription'.tr,
                                message: 'Complaint sent successfully'.tr,
                                contentType: ContentType.warning,
                              ),
                            ))
                        }
                }
              : (lessons.use_resource.toString() == "drive")
                  ? {_launchUrl(lessons.drive_url)}
                  : {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MyNewVideoPlayer(
                          url: lessons.video_url,
                        );
                      }))
                    };
        },
        title: Row(
          children: [
            Container(
              width: 120,
              child: Text(
                lessons.title.toString(),
                style: TextStyle(
                    fontFamily: 'Cobe',
                    fontWeight: FontWeight.bold,
                    fontSize: 10),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            lessons.free
                ? Text(
                    'Free',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  )
                : Icon(
                  (lessons.subscribed.toString() == "true") ? Icons.lock_open_sharp:Icons.lock,
                    color: Color(Colorbutton),
                  )
          ],
        ),
        subtitle: Text(
          lessons.description.toString(),
          style: TextStyle(
            fontFamily: 'Cobe',
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: Image.network(
          lessons.poster_url.toString(),
          height: 75,
        ),
        trailing: Text(lessons.duration.toString() + 'm'),
      ),
    );
  }

  Future<void> _launchUrl(String video_Drive_URl) async {
    final Uri _url = Uri.parse(video_Drive_URl);
    if (!await launchUrl(_url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: true,
        ))) {
      throw Exception('Could not launch $_url');
    }
  }
}

filtercolor(String studentanswer, String correctanswer, String curruntans) {
  if ((studentanswer == correctanswer) && (studentanswer == curruntans)) {
    return Colors.green;
  } else if ((studentanswer != correctanswer) &&
      (studentanswer == curruntans)) {
    return Colors.red;
  } else if ((studentanswer != correctanswer) &&
      (correctanswer == curruntans)) {
    return Colors.green;
  } else {
    return Colors.white;
  }
}
