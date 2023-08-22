import 'package:enrx_calculator/pages/micronutrients_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tabs/micronutrients_tab.dart';
import '../tabs/ons_tab.dart';
import '../tabs/rehydration_tab.dart';

class MicronutrientsPage extends StatelessWidget {
  // More app
  final Uri _moreAppUrl = Uri.parse(
      'https://apps.apple.com/us/developer/joenardson-divino/id1682679666');

  Future<void> _launchStore() async {
    if (!await launchUrl(_moreAppUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_moreAppUrl');
    }
  }

  // Open gmail
  Future<void> _launchGmail(String subject, String body) async {
    final Uri gmail = Uri.parse(
        'mailto:jsd.application@gmail.com?subject=$subject&body=$body');
    if (!await launchUrl(gmail, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Gmail');
    }
  }

  // Open messenger
  final Uri _messenger = Uri.parse('fb-messenger://user/100822268042440');

  Future<void> _launchMessenger() async {
    if (!await launchUrl(_messenger, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Messenger');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF422546),
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Micronutrients'),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: MicronutrientsTab());
  }
}
