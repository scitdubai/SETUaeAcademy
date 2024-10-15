import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:set_academy/Utils/Color.dart';
import 'package:set_academy/controls/quizzes/finish.dart';
import 'package:set_academy/model/quizzes_model.dart';
import 'package:set_academy/screen/video/ExamQuestionPage.dart';
import 'package:set_academy/screen/my_courses/my_courses_screen_firstpage.dart';
import 'package:set_academy/screen/testresult.dart';

class TestScreen extends StatefulWidget {
  final List<quizzes_model> quizzes;

  const TestScreen({super.key, required this.quizzes});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int questionIndex = 0;
  List<String> isChecked = [];
  bool onFinishButtonPressed = false;
  finish_quizzes finishQuizzes = finish_quizzes();
  late List<ExamQuestionPage> allQuestions = [];

  @override
  void initState() {
    super.initState();
    isChecked = List<String>.filled(widget.quizzes[0].questions!.length, "0");
    allQuestions = widget.quizzes[0].questions!.map((question) {
      return ExamQuestionPage(myquestion: question, ischecked: "0");
    }).toList();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'.tr),
            content: Text('Are you sure you want to exit the test?'.tr),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'.tr),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'.tr),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _finishQuiz() async {
    for (var i = 0; i < isChecked.length; i++) {
      isChecked[i] = "\"" + allQuestions[i].getreult() + "\"";
    }
    setState(() {
      onFinishButtonPressed = true;
    });
    var result = await finishQuizzes.quiz(widget.quizzes[0].id.toString(), isChecked);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return FinalResult(myvalue: result);
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Colorbutton),
          title: Text(
            widget.quizzes[0].title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 5,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCountdown(),
              SizedBox(height: 20),
              _buildQuestionIndicator(),
              SizedBox(height: 20),
              _buildQuestionContainer(height),
              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildCountdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
       
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Test Duration: '.tr,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          CircularCountDownTimer(
            duration: int.parse(widget.quizzes[0].duration.toString()) * 60,
            initialDuration: 0,
            controller: CountDownController(),
            width: 50,
            height: 50,
            ringColor: Colors.grey[300]!,
            fillColor: Color(Colorbutton),
            backgroundColor: Colors.purple[500],
            strokeWidth: 8.0,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onComplete: () {
              setState(() {
                onFinishButtonPressed = true;
              });
              _finishQuiz();
            },
          ),
          // Text(
          //   'appfontonds'.tr,
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          // ),
        ],
      ),
    );
  }

  Widget _buildQuestionIndicator() {
    return Text(
      '${questionIndex + 1}/${widget.quizzes[0].questions!.length}',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  Widget _buildQuestionContainer(double height) {
    return Container(
      height: height / 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: allQuestions[questionIndex],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: questionIndex > 0 ? _decreaseIndex : null,
            icon: Icon(Icons.arrow_back_ios, color: questionIndex == 0 ? Colors.grey : Colors.red),
          ),
          _buildFinishOrHomeButton(),
          IconButton(
            onPressed: questionIndex < allQuestions.length - 1 ? _increaseIndex : null,
            icon: Icon(Icons.arrow_forward_ios_outlined, color: questionIndex == (allQuestions.length - 1) ? Colors.grey : Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishOrHomeButton() {
    if (!onFinishButtonPressed) {
      return ElevatedButton(
        onPressed: _showFinishConfirmation,
        child: Text('Finish'.tr, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
      );
    } else {
      return SizedBox();
      // MaterialButton(
      //   color: Colors.red,
      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //   onPressed: () {
      //     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      //       return myCourses();
      //     }), (route) => false);
      //   },
      //   child: Text("Go to Home Page", style: TextStyle(color: Colors.white)),
      // );
    }
  }

  Future<void> _showFinishConfirmation() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Finish'.tr),
        content: Text('Are you sure you want to finish the test?'.tr),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'.tr),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      _finishQuiz();
    }
  }

  void saveAnswer(String answer) {
    setState(() {
      isChecked[questionIndex] = answer;
    });
  }

  String? getAnswerForCurrentQuestion() {
    return isChecked[questionIndex];
  }

  void _increaseIndex() {
    if (questionIndex < allQuestions.length - 1) {
      setState(() {
        questionIndex++;
      });
    }
  }

  void _decreaseIndex() {
    if (questionIndex > 0) {
      setState(() {
        questionIndex--;
      });
    }
  }
}
