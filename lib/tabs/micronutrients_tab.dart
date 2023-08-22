import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:enrx_calculator/pages/calculator2_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/calculator_page.dart';
import '../pages/photo_view.dart';
import '../pages/store_page.dart';

class MicronutrientsTab extends StatefulWidget {
  @override
  _MicronutrientsTabState createState() => _MicronutrientsTabState();
}

class _MicronutrientsTabState extends State<MicronutrientsTab> {
  Future<List<Map<String, dynamic>>>? _dataFuture;
  List<Map<String, dynamic>> _contentData = [];
  final int tabNo = 1;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
    );
  }

  ListView _body(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return GestureDetector(
          onTap: () {
            List<Map<String, String>> content = [];
            List<String> listString = [
              "ω-3 fatty acid (g)", "Carbohydrate (g)", "Dietary Fiber (g)", "Sodium (mg)",
              "Potassium (mg)", "Chloride (mg)", "Calcium (mg)", "Magnesium (mg)",
              "Phosphorous (mg)", "Iron (mg)", "Lutein (mcg)", "Zinc (mg)", "Selenium (μg)",
              "Copper (mg)", "Manganese (mg)", "Iodine (μg)", "Chromium (μg)",
              "Molybdenum (μg)", "Vitamin A (IU/ml)", "Vitamin D (IU/ml or cap)",
              "Vitamin E (IU)", "Vitamin K (μg)", "Vitamin B1 or Thiamine (mg)",
              "Vitamin B2 or Riboflavin (mg)", "Niacin or B3 (mg)",
              "Vitamin B6 or Pyridoxine (mg)", "Vitamin B12 or Cobalamin (μg)",
              "Folic Acid or B9 (μg)", "Pantothenic Acid or B5 (mg)",
              "Biotin or B7 (μg)", "Vitamin C (mg)", "Arginine (mg)", "Glutamine (mg)",
              "BCAA (g)",
            ];
            int toMapPosition = 0;
            for (int _repeat21 = 0; _repeat21 < listString.length; _repeat21++) {
              Map<String, String> mapfilter = {};
              mapfilter["scoops"] = item[listString[toMapPosition]].toString();
              mapfilter["nutrition"] = listString[toMapPosition];
              mapfilter["Product"] = item["Product"].toString();
              mapfilter["position"] = index.toString();
              content.add(mapfilter);
              toMapPosition++;
            }

            // Convert content list to JSON
            String contentJson = json.encode(content);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Calculator2Page(
                  contentJson: contentJson, product: item["Product"],
                ),
              ),
            );
          },
          child: IntrinsicHeight(
            child: Container(
              margin: EdgeInsets.only(
                top: index == 0 ? 6 : 3,
                bottom: index == _contentData.length - 1 ? 75 : 3,
                left: 3,
                right: 0,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (item['Product Image'] != null && item['Product Image'].isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImagePreviewPage(
                                imageUrl: item['Product Image'],
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No image available'),
                            ),
                          );
                        }
                      },
                      // conditionally load the network image
                    child: Image.asset('assets/images/product.png', height: 55, width: 55,)
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
                            item['Product'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            item['Company'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          Text(
                            item['Micronutrient'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    width: 55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (item['Store1'] != null && item['Store1'].isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StorePage(
                                      store1: item['Store1'],
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
                            child: Container(
                              width: double.infinity,
                              color: const Color(0xFFF89F5B),
                              child: const Icon(Icons.shopping_cart, color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              String subject =
                                  'EN RX Calculator: Feedback for ${item['Product']} (${item['Info']})';
                              String body = '';
                              _launchGmail(subject, body);
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.deepOrangeAccent,
                              child: const Icon(Icons.feedback, color: Colors.white),
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
        );
      },
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () async {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection, show a Snackbar
          await _showNoInternetSnackbar();
          return; // Don't proceed with the action
        }

        showRefreshDialog();
      },
      child: const Icon(Icons.refresh),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'tab_$tabNo'; // Use the correct key for tab number 0 for ENRX tab
      final jsonData = prefs.getString(key);

      if (jsonData != null) {
        final List<dynamic> listmap = json.decode(jsonData);
        _contentData = List<Map<String, dynamic>>.from(listmap);
        return _contentData;
      } else {
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
