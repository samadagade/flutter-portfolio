import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> isConnected() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  // ignore: unrelated_type_equality_checks
  if (connectivityResult == ConnectivityResult.none) {
    // No network connection at all
    return false;
  }

  // Now check actual internet access
  return await InternetConnection().hasInternetAccess;
}