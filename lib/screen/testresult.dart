import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:set_academy/Utils/Color.dart';
import 'package:set_academy/screen/Supject-session-file-exam.dart';
import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
import 'package:confetti/confetti.dart';

class FinalResult extends StatefulWidget {
  final myvalue;
  const FinalResult({super.key, required this.myvalue});

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Colorbutton),
        title: Text("Final Result"),
      ),
      body: Container(
        padding: EdgeInsets.all(10), // Padding around the main container
        child: SingleChildScrollView(
          child: Column(
            children: [
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
              Container(
                height: 730,
                child: Column(
                  children: [
                    SizedBox(height: 8),
                   Text(
                      "You got: ${widget.myvalue["right"]}/ ${widget.myvalue["total"]} (${getrange(int.parse(widget.myvalue["right"].toString()), int.parse(widget.myvalue["total"].toString()))})",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 25,
                        fontWeight: FontWeight.bold, // جعل النص غامق
                      ),
                      textAlign: TextAlign.center, // توسيط النص
                    ),

                    SizedBox(height: 8),
                    Divider(height: 2, color: Colors.black, thickness: 2),
                    Container(
                      height: 480,
                      child: ListView.builder(
                        itemCount: widget.myvalue["questions"].length,
                        itemBuilder: (context, index) {
                          final studentAnswer = widget.myvalue["questions"][index]['student_answer'].toString();
                          final correctAnswer = widget.myvalue["questions"][index]['answer'].toString();
                          final isCorrect = studentAnswer == correctAnswer;

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8), // Margin around each question
                            decoration: BoxDecoration(
                              border: Border.all(color: isCorrect ? Colors.green : Colors.red, width: 2), // Border based on correctness
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              color: Colors.white, // Background color for contrast
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10), // Padding inside the question container
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.myvalue["questions"][index]['question'] ?? "",
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  ...["a", "b", "c", "d"].map((option) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 2), // Margin around each option
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: filtercolor(studentAnswer, correctAnswer, option), width: 2), // Border based on answer correctness
                                        borderRadius: BorderRadius.circular(8), // Rounded corners for options
                                        color: Colors.transparent, // No fill color
                                      ),
                                      child: Text(
                                        widget.myvalue["questions"][index][option] ?? "",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  SizedBox(height: 8),
                                  Text(
                                    "Your answer: $studentAnswer",
                                    style: TextStyle(
                                      color: isCorrect ? Colors.green : Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Correct answer: $correctAnswer",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Divider(height: 2, color: Colors.black, thickness: 2),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(height: 2, color: Colors.black, thickness: 2),
                    MaterialButton(
                      color: Color(Colorbutton),
                      child: Text("Finished",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return myCourses();
                        }), (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getrange(int mark, int total) {
    if (mark <= (total * 50) / 100 && mark >= 0) {
      return "bad";
    } else if (mark <= (total * 75) / 100 && mark >= (total * 51) / 100) {
      return "good";
    } else if (mark <= (total * 90) / 100 && mark >= (total * 76) / 100) {
      return "very good";
    } else if (mark <= (total * 100) / 100 && mark >= (total * 91) / 100) {
      _confettiController.play();
      return "excellent";
    }
    return "";
  }

  Color filtercolor(String studentAnswer, String correctAnswer, String option) {
    if (studentAnswer == option && correctAnswer == option) {
      return Colors.green; // The correct answer
    } else if (studentAnswer == option && correctAnswer != option) {
      return Colors.red; // The selected answer is wrong
    } else if (correctAnswer == option) {
      return Colors.green; // Highlight the correct answer
    } else {
      return Colors.transparent; // Not selected
    }
  }
}






// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:set_academy/Utils/Color.dart';
// import 'package:set_academy/screen/Supject-session-file-exam.dart';
// import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
// import 'package:confetti/confetti.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class FinalResult extends StatefulWidget {
//   final myvalue;
//   const FinalResult({super.key, required this.myvalue});

//   @override
//   State<FinalResult> createState() => _FinalResultState();
// }

// Key _webViewKey = UniqueKey();

// class _FinalResultState extends State<FinalResult> {
//   void _reloadWebView() {
//     print('ss');
//     setState(() {
//       _webViewKey = UniqueKey(); // تحديث مفتاح WebView
//     });
//   }

//   String _buildHtmlString(String content) {
//     // _reloadWebView();
//     return '''
//       <html>
//       <head>
//       <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
//       <style>
//       body{
//         background:white;
//         overflow:auto;
//       }
//       p,div,span{
//         font-size:14px !important;
//       }
//       </style>
//       </head>
//       <body>
//       $content
//       </body>
//       </html>
//     ''';
//   }

//   late ConfettiController _confettiController;
//   @override
//   void initState() {
//     _confettiController =
//         ConfettiController(duration: const Duration(seconds: 5));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(Colorbutton),
//         title: Text("Final Result"),
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ConfettiWidget(
//                 confettiController: _confettiController,
//                 blastDirectionality: BlastDirectionality.explosive,
//                 shouldLoop: false,
//                 colors: const [
//                   Colors.green,
//                   Colors.blue,
//                   Colors.pink,
//                   Colors.orange,
//                   Colors.purple,
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.all(5),
//                 height: 730,
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Text(
//                       "you got : ${widget.myvalue["right"]}/ ${widget.myvalue["total"]} ${getrange(int.parse(widget.myvalue["right"].toString()), int.parse(widget.myvalue["total"].toString()))}",
//                       style: TextStyle(color: Colors.green, fontSize: 25),
//                     ),
//                     SizedBox(
//                       height: 8,
//                     ),
//                     Divider(
//                       height: 2,
//                       color: Colors.black,
//                       thickness: 2,
//                     ),
//                     Container(
//                       height: 480,
//                       child: ListView.builder(
//                         itemCount: widget.myvalue["questions"].length,
//                         itemBuilder: (context, index) {
//                           return Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                   child: Container(
//                                     height: 70,
//                                     width: 240,
//                                     // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
//                                     child: WebView(
//                                       key: _webViewKey,
//                                       initialUrl:
//                                           'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myvalue["questions"][index]['question'])))}',
//                                       javascriptMode:
//                                           JavascriptMode.unrestricted,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   color: Colors.black),
//                               Container(
//                                   padding: EdgeInsets.all(2),
//                                   child: Container(
//                                     height: 70,
//                                     width: 240,
//                                     // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
//                                     child: WebView(
//                                       key: _webViewKey,
//                                       initialUrl:
//                                           'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myvalue["questions"][index]['a'])))}',
//                                       javascriptMode:
//                                           JavascriptMode.unrestricted,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   color: filtercolor(
//                                       widget.myvalue["questions"][index]
//                                               ['student_answer']
//                                           .toString(),
//                                       widget.myvalue["questions"][index]
//                                               ['answer']
//                                           .toString(),
//                                       "a")),
//                               Container(
//                                   padding: EdgeInsets.all(2),
//                                   child: Container(
//                                     height: 70,
//                                     width: 240,
//                                     // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
//                                     child: WebView(
//                                       key: _webViewKey,
//                                       initialUrl:
//                                           'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myvalue["questions"][index]['b'])))}',
//                                       javascriptMode:
//                                           JavascriptMode.unrestricted,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   color: filtercolor(
//                                       widget.myvalue["questions"][index]
//                                               ['student_answer']
//                                           .toString(),
//                                       widget.myvalue["questions"][index]
//                                               ['answer']
//                                           .toString(),
//                                       "b")),
//                               Container(
//                                   padding: EdgeInsets.all(2),
//                                   child: Container(
//                                     height: 70,
//                                     width: 240,
//                                     // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
//                                     child: WebView(
//                                       key: _webViewKey,
//                                       initialUrl:
//                                           'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myvalue["questions"][index]['c'])))}',
//                                       javascriptMode:
//                                           JavascriptMode.unrestricted,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   color: filtercolor(
//                                       widget.myvalue["questions"][index]
//                                               ['student_answer']
//                                           .toString(),
//                                       widget.myvalue["questions"][index]
//                                               ['answer']
//                                           .toString(),
//                                       "c")),
//                               Container(
//                                   padding: EdgeInsets.all(2),
//                                   child: Container(
//                                     height: 70,
//                                     width: 240,
//                                     // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
//                                     child: WebView(
//                                       key: _webViewKey,
//                                       initialUrl:
//                                           'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myvalue["questions"][index]['d'])))}',
//                                       javascriptMode:
//                                           JavascriptMode.unrestricted,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   color: filtercolor(
//                                       widget.myvalue["questions"][index]
//                                               ['student_answer']
//                                           .toString(),
//                                       widget.myvalue["questions"][index]
//                                               ['answer']
//                                           .toString(),
//                                       "d")),
//                               Text(
//                                   "your answer : " +
//                                       widget.myvalue["questions"][index]
//                                           ['student_answer'],
//                                   style: TextStyle(
//                                       color: widget.myvalue["questions"][index]
//                                                       ['answer']
//                                                   .toString() ==
//                                               widget.myvalue["questions"][index]
//                                                       ['student_answer']
//                                                   .toString()
//                                           ? Colors.green
//                                           : Colors.red,
//                                       fontSize: 14)),
//                               Divider(
//                                 height: 2,
//                                 color: Colors.black,
//                                 thickness: 2,
//                               )
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     Divider(
//                       height: 2,
//                       color: Colors.black,
//                       thickness: 2,
//                     ),
//                     MaterialButton(
//                       color: Color(Colorbutton),
//                       child: Text("Finished",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold)),
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(context,
//                             MaterialPageRoute(builder: (context) {
//                           return myCourses();
//                         }), (route) => false);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   getrange(int mark, int total) {
//     if (mark <= (total * 50) / 100 && mark >= 0) {
//       return "bad";
//     } else if (mark <= (total * 75) / 100 && mark >= (total * 51) / 100) {
//       return "good";
//     } else if (mark <= (total * 90) / 100 && mark >= (total * 76) / 100) {
//       return "very good";
//     } else if (mark <= (total * 100) / 100 && mark >= (total * 91) / 100) {
//       _confettiController.play();
//       return "excellent";
//     }
//   }
// }
