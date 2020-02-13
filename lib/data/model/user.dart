class User {
  String location;
  bool isAdmin;
  bool isGold;
  num points;
  num coins;
  num level;
  num correctQuestions;
  num wrongQuestions;
  num accuracyPercentage;
  String sId;
  String name;
  String email;
  // Avatar avatar;
  String lastOnline;
  List<FinishedCards> finishedCards;

  User(
      {this.location,
      this.isAdmin,
      this.isGold,
      this.points,
      this.coins,
      this.level,
      this.correctQuestions,
      this.wrongQuestions,
      this.accuracyPercentage,
      this.sId,
      this.name,
      this.email,
      //  this.avatar,
      this.lastOnline,
      this.finishedCards});

  User.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    isAdmin = json['isAdmin'];
    isGold = json['isGold'];
    points = json['points'];
    coins = json['coins'];
    level = json['level'];
    correctQuestions = json['correctQuestions'];
    wrongQuestions = json['wrongQuestions'];
    accuracyPercentage = json['accuracyPercentage'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    // avatar =
    //     json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    lastOnline = json['lastOnline'];
    if (json['finishedCards'] != null) {
      finishedCards = new List<FinishedCards>();
      json['finishedCards'].forEach((v) {
        finishedCards.add(new FinishedCards.fromJson(v));
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
    data['level'] = this.level;
    data['correctQuestions'] = this.correctQuestions;
    data['wrongQuestions'] = this.wrongQuestions;
    data['accuracyPercentage'] = this.accuracyPercentage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    // if (this.avatar != null) {
    //   data['avatar'] = this.avatar.toJson();
    // }
    data['lastOnline'] = this.lastOnline;
    if (this.finishedCards != null) {
      data['finishedCards'] =
          this.finishedCards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Avatar {
  String sId;
  String avatarSvg;

  Avatar({this.sId, this.avatarSvg});

  Avatar.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    avatarSvg = json['avatarSvg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['avatarSvg'] = this.avatarSvg;
    return data;
  }
}

class FinishedCards {
  List<Cards> cards;
  String sId;
  String topicID;

  FinishedCards({this.cards, this.sId, this.topicID});

  FinishedCards.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = new List<Cards>();
      json['cards'].forEach((v) {
        cards.add(new Cards.fromJson(v));
      });
    }
    sId = json['_id'];
    topicID = json['topicID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cards != null) {
      data['cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['topicID'] = this.topicID;
    return data;
  }
}

class Cards {
  num correctInCard;
  num wrongInCard;
  num accuracyPercentageInCard;
  String sId;
  String cardID;

  Cards(
      {this.correctInCard,
      this.wrongInCard,
      this.accuracyPercentageInCard,
      this.sId,
      this.cardID});

  Cards.fromJson(Map<String, dynamic> json) {
    correctInCard = json['correctInCard'];
    wrongInCard = json['wrongInCard'];
    accuracyPercentageInCard = json['accuracyPercentageInCard'];
    sId = json['_id'];
    cardID = json['cardID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correctInCard'] = this.correctInCard;
    data['wrongInCard'] = this.wrongInCard;
    data['accuracyPercentageInCard'] = this.accuracyPercentageInCard;
    data['_id'] = this.sId;
    data['cardID'] = this.cardID;
    return data;
  }
}
