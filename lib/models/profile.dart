import 'package:gamers_and_content_creators/shared/card_enum.dart';

class Profile {

  final String name;
  final String age;
  final String location;
  final String month;
  final String day;
  final String year;
  final String profileImagePath;
  final String backgroundImagePath;
  final List<dynamic> cards;
  final String ytChannelId;

  Profile({this.name, this.age, this.location, this.month, this.day, this.year,
  this.profileImagePath, this.backgroundImagePath, this.cards, this.ytChannelId});

}