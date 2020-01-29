class Question {
  int correctNumber;
  int wrongNumber;
  num questionLevel;
  String sId;
  String topicID;
  String cardID;
  String questionID;
  String question;
  List<Answers> answers;
  int iV;

  Question(
      {this.correctNumber,
      this.wrongNumber,
      this.questionLevel,
      this.sId,
      this.topicID,
      this.cardID,
      this.questionID,
      this.question,
      this.answers,
      this.iV});

  Question.fromJson(Map<String, dynamic> json) {
    correctNumber = json['correctNumber'];
    wrongNumber = json['wrongNumber'];
    questionLevel = json['questionLevel'];
    sId = json['_id'];
    topicID = json['topicID'];
    cardID = json['cardID'];
    questionID = json['questionID'];
    question = json['question'];
    if (json['answers'] != null) {
      answers = new List<Answers>();
      json['answers'].forEach((v) {
        answers.add(new Answers.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correctNumber'] = this.correctNumber;
    data['wrongNumber'] = this.wrongNumber;
    data['questionLevel'] = this.questionLevel;
    data['_id'] = this.sId;
    data['topicID'] = this.topicID;
    data['cardID'] = this.cardID;
    data['questionID'] = this.questionID;
    data['question'] = this.question;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Answers {
  String sId;
  String answer;
  bool isCorrect;

  Answers({this.sId, this.answer, this.isCorrect});

  Answers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    answer = json['answer'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['answer'] = this.answer;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}
