import'dart:convert';
import 'dart:io';
import 'package:gamers_and_content_creators/shared/keys.dart';
import 'package:http/http.dart' as http;

class TwitchApiService {
  TwitchApiService.instantiate();

  static final TwitchApiService instance = TwitchApiService.instantiate();

  final String _baseUrl = 'id.twitch.tv';

  //call this if access token does not exist
  Future getAccessToken() async{
    Map<String, String> parameters = {
      'client_id': TWITCH_CLIENT_ID,
      'client_secret': TWITCH_CLIENT_SECRET,
      'grant_type':'client_credentials'
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/oauth2/token',
      parameters,
    );
    print(uri);
    //get token
    var response = await http.post(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      var token = data['access_token'];
      print(token);
      return token;
    } else {
      throw json.decode(response.body);
    }
  }
}