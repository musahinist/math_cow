class User {
  bool isAdmin;
  int points;
  int accuracyPercentage;
  String sId;
  String name;
  String email;
  int iV;

  User(
      {this.isAdmin,
      this.points,
      this.accuracyPercentage,
      this.sId,
      this.name,
      this.email,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    isAdmin = json['isAdmin'];
    points = json['points'];
    accuracyPercentage = json['accuracyPercentage'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAdmin'] = this.isAdmin;
    data['points'] = this.points;
    data['accuracyPercentage'] = this.accuracyPercentage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['__v'] = this.iV;
    return data;
  }
}
