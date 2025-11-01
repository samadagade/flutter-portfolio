import 'package:portfolio/core/util/coming_soon_snackbar.dart';
import 'package:portfolio/core/util/connection_checker.dart';
import 'package:portfolio/core/util/no_internet_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchLink(String url, context) async {
  bool isOnline = await isConnected();
  final Uri uri = Uri.parse(url);
  if (isOnline) {
    if (url.isEmpty || url.contains("example.com")) {
      comingSoonSnackbar(context);
      return;
    } else {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  } else {
    noInternetSnackbar(context);
  }
}