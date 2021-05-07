import 'package:gamers_and_content_creators/shared/card_enum.dart';

class UserModel {

  final String uid;

  UserModel({ this.uid });
}

class UserData {
  final String uid;
  final String name;
  final String age;
  final String location;
  final int month;
  final int day;
  final int year;
  final String profileImagePath;
  final String backgroundImagePath;
  final List<dynamic> cards;
  final String ytChannelId;

  UserData({this.uid, this.name, this.age, this.location, this.month, this.day, this.year,
  this.profileImagePath, this.backgroundImagePath, this.cards, this.ytChannelId});

}