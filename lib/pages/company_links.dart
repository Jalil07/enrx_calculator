import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/web_page.dart';

class CompanyLinksPage extends StatefulWidget {
  const CompanyLinksPage({super.key});

  @override
  State<CompanyLinksPage> createState() => _CompanyLinksPageState();
}

class _CompanyLinksPageState extends State<CompanyLinksPage> {
  Future<List<Map<String, dynamic>>>? _dataFuture;
  List<Map<String, dynamic>> _contentData = [];
  final int tabNo = 8;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF422546),
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Company Links', style: TextStyle(color: Colors.white),),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: () {
                String subject =
                    'EN RX Calculator: Sharing Company Link';
                String body = '';
                _launchGmail(subject, body);
              },
              child: const Opacity(
                opacity: 0.6,
                child: Text(
                  'Share Your Link',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Please wait retrieving data'),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch data for this tab.'),
            );
          } else if (snapshot.hasData) {
            final List<Map<String, dynamic>> data = snapshot.data!;
            return Scaffold(
              body: _body(data),
              floatingActionButton: _fab(),
            );
          } else {
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }

  ListView _body(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(
              top: index == 0 ? 6 : 3,
              bottom: index == data.length - 1 ? 75 : 3,
              left: 3,
              right: 0,
            ),
            color: Colors.white,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/image3.png',
                  height: 55,
                  width: 55,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['Company'],
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  color: const Color(0xFFF89F5B),
                                  child: TextButton(
                                    onPressed: () {
                                      if (item['Links'] != null && item['Links'].isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WebPage(
                                              linkUrl: item['Links'], title: item['Company'],
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Link to Follow'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Open Link',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.deepOrangeAccent,
                                  child:
                                  TextButton(
                                    onPressed: () {
                                      String subject =
                                          'EN RX Calculator: Report Company Link (${item['Company']})';
                                      String body = '';
                                      _launchGmail(subject, body);
                                    },
                                    child: const Text(
                                      'Report Link',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF422546),
      onPressed: () async {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
          // No internet connection, show a Snack bar
          await _showNoInternetSnackbar();
          return; // Don't proceed with the action
        }
        showRefreshDialog();
      },
      child: const Icon(Icons.refresh, color: Colors.white,),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key =
          'tab_$tabNo'; // Use the correct key for tab number 0 for ENRX tab
      final jsonData = prefs.getString(key);

      if (jsonData != null) {
        final List<dynamic> listmap = json.decode(jsonData);
        _contentData = List<Map<String, dynamic>>.from(listmap);
        return _contentData;
      } else {
        // Check internet connection first
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none) || connectivityResult.isEmpty) {
          // No internet connection, show a Snack bar and exit early
          _showNoInternetSnackbar(); // Note: No need to await here since we're just showing a snackbar
          return []; // Return an empty list or handle accordingly
        }
        final url =
            'https://script.google.com/macros/s/AKfycbxPvnwJiFbH0A9kya106YQ-JqRgF_gGKspxPdN-cfMvJ0fJVMiwcVTrdbvGmt9PCFIuhQ/exec?action=getMany&tabno=$tabNo&from=2&to=1000';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final List<dynamic> listmap = json.decode(response.body);
          _contentData = List<Map<String, dynamic>>.from(listmap);

          // Save data to shared preferences
          final jsonData = json.encode(_contentData);
          await prefs.setString(key, jsonData);

          return _contentData;
        } else {
          // Handle error
          return [];
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> _showNoInternetSnackbar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection!'),
      ),
    );
  }

  Future<void> _refreshData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'tab_$tabNo';
    final sharedPrefs = await prefs;
    // Clear the shared preferences
    sharedPrefs.remove(key);
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  Future<dynamic> showRefreshDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Refreshing data will take time. Continue?',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _refreshData();
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  //open gmail
  Future<void> _launchGmail(String subject, String body) async {
    final Uri gmail = Uri.parse(
        'mailto:enrxcalculator2022@gmail.com?subject=$subject&body=$body');
    if (!await launchUrl(gmail, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Gmail');
    }
  }
}
