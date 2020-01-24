class User {
  bool isAdmin;
  int points;
  int correctQuestions;
  int wrongQuestions;
  num accuracyPercentage;
  String sId;
  String name;
  String email;
  List<FinishedCards> finishedCards;
  String lastOnline;

  User(
      {this.isAdmin,
      this.points,
      this.correctQuestions,
      this.wrongQuestions,
      this.accuracyPercentage,
      this.sId,
      this.name,
      this.email,
      this.finishedCards,
      this.lastOnline});

  User.fromJson(Map<String, dynamic> json) {
    isAdmin = json['isAdmin'];
    points = json['points'];
    correctQuestions = json['correctQuestions'];
    wrongQuestions = json['wrongQuestions'];
    accuracyPercentage = json['accuracyPercentage'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    if (json['finishedCards'] != null) {
      finishedCards = new List<FinishedCards>();
      json['finishedCards'].forEach((v) {
        finishedCards.add(new FinishedCards.fromJson(v));
      });
    }
    lastOnline = json['lastOnline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAdmin'] = this.isAdmin;
    data['points'] = this.points;
    data['correctQuestions'] = this.correctQuestions;
    data['wrongQuestions'] = this.wrongQuestions;
    data['accuracyPercentage'] = this.accuracyPercentage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.finishedCards != null) {
      data['finishedCards'] =
          this.finishedCards.map((v) => v.toJson()).toList();
    }
    data['lastOnline'] = this.lastOnline;
    return data;
  }
}

class FinishedCards {
  String topicID;
  String cardID;

  FinishedCards({this.topicID, this.cardID});

  FinishedCards.fromJson(Map<String, dynamic> json) {
    topicID = json['topicID'];
    cardID = json['cardID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicID'] = this.topicID;
    data['cardID'] = this.cardID;
    return data;
  }
}
