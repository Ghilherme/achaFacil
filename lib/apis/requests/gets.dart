import 'package:url_launcher/url_launcher.dart';

class Gets {
  static Future<bool> launchExternal(String url) async {
    return await canLaunch(url) ? launch(url) : false;
  }
}
