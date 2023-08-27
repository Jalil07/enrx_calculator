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

  String _searchQuery = ''; // State to hold the search query
  bool _isSearchBarHidden = true; // State to track whether the search bar is hidden or not

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
          title: _isSearchBarHidden
              ? Container() // Set text color to white
              : Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1.0), // Add 2-pixel white border
              borderRadius: BorderRadius.circular(8), // Add rounded corners
            ),
            child: TextField(
              style: const TextStyle(color: Colors.black), // Set text color to white
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update the search query
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey), // Set hint text color
                // suffix: Icon(Icons.clear, color: Colors.grey, size: 20,), // Set icon color
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Remove the line below the search bar
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent), // Remove the line below the search bar
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              splashRadius: 25,
              onPressed: () {
                setState(() {
                  _isSearchBarHidden = !_isSearchBarHidden; // Toggle the search bar
                  _searchQuery = ''; // Clear the search query when toggling
                });
              },
              icon: Icon(_isSearchBarHidden ? Icons.search : Icons.clear),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  ONSTab(searchQuery: _searchQuery), // Pass search query to tab
                  RehydrationTab(searchQuery: _searchQuery), // Pass search query to tab
                ],
              ),
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
