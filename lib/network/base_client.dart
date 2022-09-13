import 'dart:convert';
import 'package:demo_offline/constants/url_constants.dart';
import 'package:http/http.dart' as http;

class BaseClient{
  static final BaseClient _instance =  BaseClient._();
  BaseClient._();
  static BaseClient get instance => _instance;
  static const int timeDuration = 90;

  Future<dynamic> get(String api) async{
    var uri = Uri.parse(UrlConstants.baseUrl + api);
    try{
      var response = await http.get(uri).timeout(const Duration(seconds: timeDuration));
      return _processResponse(response);
    }on Exception{
      throw "Error";
    }
  }


  dynamic _processResponse(http.Response response){
    if(response.statusCode >= 200 && response.statusCode <=299){
      return utf8.decode(response.bodyBytes);
    }
  }
}