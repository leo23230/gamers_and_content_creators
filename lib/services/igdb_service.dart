import'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class IGDBService{

  IGDBService.instantiate();

  static final IGDBService instance = IGDBService.instantiate();

  final String _baseUrl = "api.igdb.com";

  Future search() async{
    Uri uri = Uri.https(
      _baseUrl,
      '/v4/games/',
      //parameters,
    );
    //create headers and body of request using maps
    // "" : ""
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Map<String, String> body = {
    };

    http.post(uri, headers: headers, body: body);
  }

}