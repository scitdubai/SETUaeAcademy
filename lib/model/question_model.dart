class question_model {
  dynamic question;
  dynamic a;
  dynamic b;
  dynamic c;
  dynamic d;
  dynamic answer;
  bool hasQuestionImg;
  bool hasAImg;
  bool hasBImg;
  bool hasCImg;
  bool hasDImg;
  String questionImg;
  String aImg;
  String bImg;
  String cImg;
  String dImg;

  question_model({
    required this.question,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.answer,
    required this.hasQuestionImg,
    required this.hasAImg,
    required this.hasBImg,
    required this.hasCImg,
    required this.hasDImg,
    required this.questionImg,
    required this.aImg,
    required this.bImg,
    required this.cImg,
    required this.dImg,
  });

  factory question_model.fromJson(Map<String, dynamic> json) {
    return question_model(
      question: json['question'] as dynamic,
      a: json['a'] as dynamic,
      b: json['b'] as dynamic,
      c: json['c'] as dynamic,
      d: json['d'] as dynamic,
      answer: json['answer'] as dynamic,
      hasQuestionImg: json['has_question_img'] as bool,
      hasAImg: json['has_a_img'] as bool,
      hasBImg: json['has_b_img'] as bool,
      hasCImg: json['has_c_img'] as bool,
      hasDImg: json['has_d_img'] as bool,
      questionImg: json['question_img'] as String,
      aImg: json['a_img'] as String,
      bImg: json['b_img'] as String,
      cImg: json['c_img'] as String,
      dImg: json['d_img'] as String,
    );
  }
}
