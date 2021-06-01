class UserModel {

  final String uid;

  UserModel({ this.uid });
}

class UserData {
  final String uid;
  final String name;
  final String age;
  final List<dynamic> location;
  final dynamic geoHash;
  final int month;
  final int day;
  final int year;
  final String profileImagePath;
  final String backgroundImagePath;
  final List<dynamic> cards;
  final String ytChannelId;
  final String bioTitle;
  final String bioBody;

  UserData({this.uid, this.name, this.age, this.location, this.geoHash, this.month, this.day, this.year,
  this.profileImagePath, this.backgroundImagePath, this.cards, this.ytChannelId,
  this.bioTitle, this.bioBody});

}