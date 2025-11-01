import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

launchMailto() async {
  final mailtoLink = Mailto(
    to: ['samarthdagade@gmail.com'],
    cc: ['samarthdagade8313@gmail.com'],
    subject: 'Contact via Portfolio App',
    body: 'Hi Samarth,\n\nI saw your portfolio and would like to get in touch about...',
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}