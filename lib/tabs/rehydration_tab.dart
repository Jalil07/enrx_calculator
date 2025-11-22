import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:enrx_calculator/pages/calculator2_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/photo_view.dart';
import '../pages/web_page.dart';

class RehydrationTab extends StatefulWidget {
  final String searchQuery; // Search query passed from TFFormulaPage

  const RehydrationTab({super.key, required this.searchQuery});

  @override
  State<RehydrationTab> createState() => _RehydrationTabState();
}

class _RehydrationTabState extends State<RehydrationTab> {
  Future<List<Map<String, dynamic>>>? _dataFuture;
  List<Map<String, dynamic>> _contentData = [];
  final int tabNo = 4;

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
          final filteredData = _filterData(data); // Filter data based on search query
          return Scaffold(
            body: _body(filteredData),
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

  List<Map<String, dynamic>> _filterData(List<Map<String, dynamic>> data) {
    if (widget.searchQuery.isEmpty) {
      return data; // If search query is empty, return all data
    }

    // Filter data based on search query
    return data.where((item) {
      return item['Product']
          .toString()
          .toLowerCase()
          .contains(widget.searchQuery.toLowerCase());
    }).toList();
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
              "Calories",
              "CHO (g)",
              "Protein",
              "Na (mg)",
              "K (mg)",
              "Cl (mEq/L)",
              "Mg (mg)",
              "Ca (mg)",
            ];
            int toMapPosition = 0;
            for (int _repeat21 = 0;
                _repeat21 < listString.length;
                _repeat21++) {
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
                  contentJson: contentJson,
                  product: item["Product"],
                  label: 'Number of bottles',
                  supplement: 'Supplements per bottle',
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
                      if (item['Product Image'] != null &&
                          item['Product Image'].isNotEmpty) {
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
                    child: CachedNetworkImage(
                      imageUrl: item['Product Image']!,
                      height: 55,
                      width: 55,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white,
                        size: 55,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  item['Product'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (item['Vegan'] == 'Vegan')
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Product Info'),
                                          content: const Text('This product is certified vegetarian-safe.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Image.asset('assets/images/vegan.png', height: 15, width: 15),
                                ),
                              const SizedBox(width: 8),
                              if (item['Halal'] == 'Halal')
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Product Info'),
                                          content: const Text('This product is Halal certified.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Image.asset('assets/images/halal.png', height: 15, width: 15),
                                ),
                            ],
                          ),
                          Text(
                            item['Company'],
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          Text(
                            item['Info'],
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
                              if (item['Store1'] != null &&
                                  item['Store1'].isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WebPage(
                                      linkUrl: item['Store1'],
                                      title: 'Request Order',
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
                              child: const Icon(Icons.shopping_cart,
                                  color: Colors.white),
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
                              child: const Icon(Icons.feedback,
                                  color: Colors.white),
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
