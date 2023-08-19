import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tabs/tf_formula_tab.dart';
import '../tabs/rehydration_tab.dart';

class TFFormulaPage extends StatefulWidget {
  @override
  State<TFFormulaPage> createState() => _TFFormulaPageState();
}

class _TFFormulaPageState extends State<TFFormulaPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _tabs = [
    TFFormulaTab(),
    RehydrationTab(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.history_edu),
              label: 'ONS/TF Formulas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.diversity_3),
              label: 'Rehydration Solution',
            ),
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
