class User {
  String location;
  bool isAdmin;
  bool isGold;
  int points;
  int coins;
  int correctQuestions;
  int wrongQuestions;
  num accuracyPercentage;
  String sId;
  String name;
  String email;
  String lastOnline;
  List<FinishedCards> finishedCards;
  List<FinishedQuestions> finishedQuestions;

  User(
      {this.location,
      this.isAdmin,
      this.isGold,
      this.points,
      this.coins,
      this.correctQuestions,
      this.wrongQuestions,
      this.accuracyPercentage,
      this.sId,
      this.name,
      this.email,
      this.lastOnline,
      this.finishedCards,
      this.finishedQuestions});

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    isAdmin = json['isAdmin'];
    isGold = json['isGold'];
    points = json['points'];
    coins = json['coins'];
    correctQuestions = json['correctQuestions'];
    wrongQuestions = json['wrongQuestions'];
    accuracyPercentage = json['accuracyPercentage'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    lastOnline = json['lastOnline'];
    if (json['finishedCards'] != null) {
      finishedCards = new List<FinishedCards>();
      json['finishedCards'].forEach((v) {
        finishedCards.add(new FinishedCards.fromJson(v));
      });
    }
    if (json['finishedQuestions'] != null) {
      finishedQuestions = new List<FinishedQuestions>();
      json['finishedQuestions'].forEach((v) {
        finishedQuestions.add(new FinishedQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['isAdmin'] = this.isAdmin;
    data['isGold'] = this.isGold;
    data['points'] = this.points;
    data['coins'] = this.coins;
    data['correctQuestions'] = this.correctQuestions;
    data['wrongQuestions'] = this.wrongQuestions;
    data['accuracyPercentage'] = this.accuracyPercentage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['lastOnline'] = this.lastOnline;
    if (this.finishedCards != null) {
      data['finishedCards'] =
          this.finishedCards.map((v) => v.toJson()).toList();
    }
    if (this.finishedQuestions != null) {
      data['finishedQuestions'] =
          this.finishedQuestions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FinishedCards {
  int correctInCard;
  int wrongInCard;
  num accuracyPercentageInCard;
  String sId;
  String topicID;
  String cardID;

  FinishedCards(
      {this.correctInCard,
      this.wrongInCard,
      this.accuracyPercentageInCard,
      this.sId,
      this.topicID,
      this.cardID});

  FinishedCards.fromJson(Map<String, dynamic> json) {
    correctInCard = json['correctInCard'];
    wrongInCard = json['wrongInCard'];
    accuracyPercentageInCard = json['accuracyPercentageInCard'];
    sId = json['_id'];
    topicID = json['topicID'];
    cardID = json['cardID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correctInCard'] = this.correctInCard;
    data['wrongInCard'] = this.wrongInCard;
    data['accuracyPercentageInCard'] = this.accuracyPercentageInCard;
    data['_id'] = this.sId;
    data['topicID'] = this.topicID;
    data['cardID'] = this.cardID;
    return data;
  }
}

class FinishedQuestions {
  String questionId;
  bool isCorrect;

  FinishedQuestions({this.questionId, this.isCorrect});

  FinishedQuestions.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}
