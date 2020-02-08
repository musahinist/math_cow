class Question {
  String semanticQuestion;
  String semanticAnswer;
  List<String> trainingQuestion;
  int correctNumber;
  int wrongNumber;
  num questionLevel;
  String sId;
  String topicID;
  String cardID;
  String questionID;
  int layoutType;
  String question;
  List<Answers> answers;

  Question(
      {this.semanticQuestion,
      this.semanticAnswer,
      this.trainingQuestion,
      this.correctNumber,
      this.wrongNumber,
      this.questionLevel,
      this.sId,
      this.topicID,
      this.cardID,
      this.questionID,
      this.layoutType,
      this.question,
      this.answers});

  Question.fromJson(Map<String, dynamic> json) {
    semanticQuestion = json['semanticQuestion'];
    semanticAnswer = json['semanticAnswer'];
    trainingQuestion = json['trainingQuestion'].cast<String>();
    correctNumber = json['correctNumber'];
    wrongNumber = json['wrongNumber'];
    questionLevel = json['questionLevel'];
    sId = json['_id'];
    topicID = json['topicID'];
    cardID = json['cardID'];
    questionID = json['questionID'];
    layoutType = json['layoutType'];
    question = json['question'];
    if (json['answers'] != null) {
      answers = new List<Answers>();
      json['answers'].forEach((v) {
        answers.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['semanticQuestion'] = this.semanticQuestion;
    data['semanticAnswer'] = this.semanticAnswer;
    data['trainingQuestion'] = this.trainingQuestion;
    data['correctNumber'] = this.correctNumber;
    data['wrongNumber'] = this.wrongNumber;
    data['questionLevel'] = this.questionLevel;
    data['_id'] = this.sId;
    data['topicID'] = this.topicID;
    data['cardID'] = this.cardID;
    data['questionID'] = this.questionID;
    data['layoutType'] = this.layoutType;
    data['question'] = this.question;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  String answer;
  bool isCorrect;

  Answers({this.answer, this.isCorrect});

  Answers.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}
