class User {
  bool isAdmin;
  int points;
  int accuracyPercentage;
  String sId;
  String name;
  String email;
  List<FinishedCards> finishedCards;

  User(
      {this.isAdmin,
      this.points,
      this.accuracyPercentage,
      this.sId,
      this.name,
      this.email,
      this.finishedCards});

  User.fromJson(Map<String, dynamic> json) {
    isAdmin = json['isAdmin'];
    points = json['points'];
    accuracyPercentage = json['accuracyPercentage'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    // if (json['finishedCards'] != null) {
    //   finishedCards = new List<FinishedCards>();
    //   json['finishedCards'].forEach((v) {
    //     finishedCards.add(new FinishedCards.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAdmin'] = this.isAdmin;
    data['points'] = this.points;
    data['accuracyPercentage'] = this.accuracyPercentage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.finishedCards != null) {
      data['finishedCards'] =
          this.finishedCards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FinishedCards {
  String tpicID;
  String cardID;

  FinishedCards({this.tpicID, this.cardID});

  FinishedCards.fromJson(Map<String, dynamic> json) {
    tpicID = json['tpicID'];
    cardID = json['cardID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tpicID'] = this.tpicID;
    data['cardID'] = this.cardID;
    return data;
  }
}
