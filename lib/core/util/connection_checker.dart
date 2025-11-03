import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkUtils {
  static final InternetConnection _internetChecker = InternetConnection();

  static Future<bool> get isConnected async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) return false;
    return await _internetChecker.hasInternetAccess;
  }
}