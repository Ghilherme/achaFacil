import 'package:AchaFacil/models/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class Gets {
  static Future<bool> launchExternal(String url) async {
    return await canLaunch(url) ? launch(url) : false;
  }

  static Future<ContactsModel> getUserInfo(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('contatos')
        .where('email', isEqualTo: email)
        .get();
    return ContactsModel.fromFirestore(query.docs.first);
  }
}
