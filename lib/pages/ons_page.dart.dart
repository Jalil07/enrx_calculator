import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tabs/ons_tab.dart';
import '../tabs/rehydration_tab.dart';

class TFFormulaPage extends StatefulWidget {
  @override
  State<TFFormulaPage> createState() => _TFFormulaPageState();
}

class _TFFormulaPageState extends State<TFFormulaPage> {
  final List<Tab> _tabs = [
    const Tab(text: 'ONS/TF Formulas'),
    const Tab(text: 'Rehydration Solution'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF422546),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            tabs: _tabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            ONSTab(),
            RehydrationTab(),
          ],
        ),
      ),
    );
  }

  //More app
  final Uri _moreAppUrl = Uri.parse(
      'https://apps.apple.com/us/developer/joenardson-divino/id1682679666');

  Future<void> _launchStore() async {
    if (!await launchUrl(_moreAppUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_moreAppUrl');
    }
  }

  //open gmail
  Future<void> _launchGmail(String subject, String body) async {
    final Uri gmail = Uri.parse(
        'mailto:jsd.application@gmail.com?subject=$subject&body=$body');
    if (!await launchUrl(gmail, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Gmail');
    }
  }

  //open messenger
  final Uri _messenger = Uri.parse('fb-messenger://user/100822268042440');

  Future<void> _launchMessenger() async {
    if (!await launchUrl(_messenger, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Messenger');
    }
  }
}
