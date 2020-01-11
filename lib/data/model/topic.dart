class Topic {
  String sId;
  String topicID;
  String topicName;
  List<Cards> cards;

  Topic({this.sId, this.topicID, this.topicName, this.cards});

  Topic.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    topicID = json['topicID'];
    topicName = json['topicName'];
    if (json['cards'] != null) {
      cards = new List<Cards>();
      json['cards'].forEach((v) {
        cards.add(new Cards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['topicID'] = this.topicID;
    data['topicName'] = this.topicName;
    if (this.cards != null) {
      data['cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  String sId;
  String cardID;
  String cardName;

  Cards({this.sId, this.cardID, this.cardName});

  Cards.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    cardID = json['cardID'];
    cardName = json['cardName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['cardID'] = this.cardID;
    data['cardName'] = this.cardName;
    return data;
  }
}
