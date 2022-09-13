import 'package:connectivity_plus/connectivity_plus.dart';

class Reachability{
  static Future<bool?> isInternetAvailable() async{
    var connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      return true;
    }else{
      return false;
    }
  }
}