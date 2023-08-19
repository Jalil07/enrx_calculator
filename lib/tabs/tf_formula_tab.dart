import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/calculator_page.dart';

class TFFormulaTab extends StatefulWidget {
  @override
  _TFFormulaTabState createState() => _TFFormulaTabState();
}

class _TFFormulaTabState extends State<TFFormulaTab> {
  Future<List<Map<String, dynamic>>>? _dataFuture;
  List<Map<String, dynamic>> _contentData = [];
  final int tabNo = 0;

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
                  Text('Sabr while we are retrieving data'),
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
              "weight (g)", "Energy (kcal)", "Water (mL)", "Protein Amino Acid (g)",
              "Fat (g)", "ω-3 fatty acid (g)", "Carbohydrate (g)", "Dietary Fiber (g)",
              "Sodium (mg)", "Potassium (mg)", "Chloride (mg)", "Calcium (mg)",
              "Magnesium (mg)", "Phosphorous (mg)", "Iron (mg)", "Zinc (mg)",
              "Selenium (μg)", "Copper (mg)", "Manganese (mg)", "Iodine (μg)",
              "Chromium (μg)", "Molybdenum (μg)", "Vitamin A (μg)", "Vitamin D (μg)",
              "Vitamin E (IU)", "Vitamin K (μg)", "Vitamin B1 (mg)", "Vitamin B2 (mg)",
              "Niacin (mg)", "Vitamin B6 (mg)", "Vitamin B12 (μg)", "Folic Acid (μg)",
              "Pantothenic Acid (mg)", "Biotin (μg)", "Vitamin C (mg)", "Arginine (mg)",
              "Glutamine (mg)", "BCAA (g)"
            ];
            int toMapPosition = 0;
            for (int _repeat21 = 0; _repeat21 < listString.length; _repeat21++) {
              Map<String, String> mapfilter = {};
              mapfilter["scoops"] = item[listString[toMapPosition]].toString();
              mapfilter["calorie"] = item[listString[toMapPosition] + " calorie"].toString();
              mapfilter["nutrition"] = listString[toMapPosition];
              mapfilter["Product"] = item["Product"].toString();
              mapfilter["Input"] = item["Input"].toString();
              mapfilter["position"] = index.toString();
              content.add(mapfilter);
              toMapPosition++;
            }
            // Convert content list to JSON
            String contentJson = json.encode(content);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalculatorPage(
                  contentJson: contentJson,
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
                  right: 3),
              color: Colors.white,
              child: Row(
                children: [
                  Image.network(item['Product Image'], height: 45, width: 45,),
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
                                fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                          ),
                          Text(
                            item['Formula'],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          Text(
                            item['Info'],
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      ),
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
      backgroundColor: Colors.deepOrangeAccent,
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
}
